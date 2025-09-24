//
//  PlayerViewModel.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 05/12/23.
//

import Foundation
import AVFoundation
import MediaPlayer

final class PlayerViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var feed: [AudioModel] = [] {
        didSet {
            try? self.getAudio()
        }
    }
    
    @Published var isDownloaded: Bool = false
    @Published var isDownloading: Bool = false
    @Published var playerIsReady: Bool = false
    
    @Published var isPlaying: Bool = false {
        didSet {
            if isPlaying == false {
                DispatchQueue.main.async { [weak self] in
                    self?.player?.stop()
                }
            }
        }
    }
    
    @Published var audioDuration: Double = 0
    @Published var currentTime: Double = 0 {
        didSet {
            if abs(currentTime - oldValue) > 3 {
                if let player {
                    player.currentTime = currentTime
                }
            }
        }
    }
    
    @Published var remoteAudioIsReady: Bool = false
    @Published var remoteAudioIsPlaying: Bool = false
    @Published var remoteAudioDuration: CMTime = CMTime(seconds: 60, preferredTimescale: .min)
    @Published var remoteAudioCurrentTime: CMTime = CMTime(seconds: 0, preferredTimescale: .min) {
        didSet {
            if (abs(Float(remoteAudioCurrentTime.seconds) - Float(oldValue.seconds))) > 3 {
                if let remotePlayer {
                    remotePlayer.seek(to: remoteAudioCurrentTime, toleranceBefore: .zero, toleranceAfter: .zero) { result in
                        print("AFTER CHANGING REMOTE AUDIO CURRENT TIME")
                        print(result.description)
                    }
                }
            }
        }
    }
    
    @Published var currentId: UUID = LocalData.shared.allAudios[0].id {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.isPlaying = false
            }
            try? self.getAudio()
        }
    }
    @Published var audioType: AudioModel.AudioType? {
        didSet {
            if let audioType {
                DispatchQueue.main.async { [weak self] in
                    self?.feed = LocalData.shared.allAudios.filter { $0.type == audioType }
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.feed = []
                }
            }
        }
    }
    
    deinit {
        player = nil
        remotePlayer = nil
    }
    
    var player: AVAudioPlayer? {
        didSet {
            if player != nil {
                remotePlayer = nil
            }
        }
    }
    var remotePlayer: AVPlayer?
    private var remoteEndObserver: Any?
    
    // MARK: Sleep Timer
    @Published var sleepTimerIsActive: Bool = false
    @Published var sleepRemainingSeconds: TimeInterval = 0
    private var sleepTimer: Timer?
    
    @MainActor
    func play() {
        if let player {
            player.play()
            isPlaying = true
        }
        if let remotePlayer {
            remotePlayer.play()
            remoteAudioIsPlaying = true
        }
    }
    
    @MainActor
    func stop() {
        if let player {
            player.stop()
            isPlaying = false
        }
        if let remotePlayer {
            remotePlayer.pause()
            remoteAudioIsPlaying = false
        }
        // Do not auto-cancel sleep timer here; user may resume before it ends.
    }
    
    @MainActor
    func forward30() {
        if let player {
            player.currentTime += (player.duration - currentTime) < 30 ? player.duration - currentTime - 1 : 30
        }
        if let remotePlayer {

            remotePlayer.seek(to: CMTime(seconds: min(remoteAudioCurrentTime.seconds + 30.0, remoteAudioDuration.seconds - 1.0), preferredTimescale: remoteAudioDuration.timescale), toleranceBefore: .zero, toleranceAfter: .zero) { result in
                print("FORWARD 30 RESULT: \(result)")
            }
        }
    }
    
    @MainActor
    func back15() {
        if let player {
            player.currentTime -= player.currentTime < 15 ? player.currentTime : 15
        }
        if let remotePlayer {
            remotePlayer.seek(to: max(CMTime(seconds: 0, preferredTimescale: .max), remoteAudioCurrentTime - CMTime(seconds: 15, preferredTimescale: remoteAudioDuration.timescale)), toleranceBefore: .zero, toleranceAfter: .zero) { result in
                print("BACK 15 RESULT \(result)")
            }
        }
    }

    @MainActor
    func restartFromBeginning() {
        if let player {
            player.currentTime = 0
        }
        if let remotePlayer {
            remotePlayer.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero) { result in
                print("RESTART RESULT: \(result)")
            }
        }
    }
    
    func updateCurrentTime() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] timer in
            if let player = self?.player {
                DispatchQueue.main.async { [weak self] in
                    self?.currentTime = player.currentTime
                }
            }
            if let remotePlayer = self?.remotePlayer {
                DispatchQueue.main.async { [weak self] in
                    self?.remoteAudioCurrentTime = remotePlayer.currentTime()
                    if let currentItem = remotePlayer.currentItem {
                        self?.remoteAudioDuration = currentItem.duration
                    }
                }
            }
        }
    }

    // MARK: Sleep Timer API
    @MainActor
    func startSleepTimer(totalSeconds: TimeInterval) {
        self.sleepTimer?.invalidate()
        // Clamp to 0...10800 (180 minutes)
        self.sleepRemainingSeconds = min(10800, max(0, totalSeconds))
        self.sleepTimerIsActive = self.sleepRemainingSeconds > 0
        if self.sleepTimerIsActive == false { return }
        self.sleepTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self else { return }
            self.sleepRemainingSeconds = max(0, self.sleepRemainingSeconds - 1.0)
            if self.sleepRemainingSeconds <= 0 {
                self.sleepTimerIsActive = false
                timer.invalidate()
                self.sleepTimer = nil
                self.stop()
            }
        }
        RunLoop.main.add(self.sleepTimer!, forMode: .common)
    }
    
    @MainActor
    func cancelSleepTimer() {
        self.sleepTimer?.invalidate()
        self.sleepTimer = nil
        self.sleepTimerIsActive = false
        self.sleepRemainingSeconds = 0
    }
    
    func getAudio() throws {
        if let currentAudio = currentAudio() {
            if let data = LocalFileManager.shared.getAudio(name: currentAudio.title.localized) {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
                self.setupRemoteControl()
                self.player = try AVAudioPlayer(data: data)
                self.player?.delegate = self
                self.player?.numberOfLoops = 0
                DispatchQueue.main.async { [weak self] in
                    self?.isDownloaded = true
                    self?.playerIsReady = true
                    self?.audioDuration = self?.player?.duration ?? 0
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.isDownloaded = false
                    self?.playerIsReady = false
                    self?.player = nil
                }
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
                self.setupRemoteControl()
                // tear down previous observer if any
                if let remoteEndObserver {
                    NotificationCenter.default.removeObserver(remoteEndObserver)
                    self.remoteEndObserver = nil
                }
                self.remotePlayer = AVPlayer(url: URL(string: currentAudio.downloadUrl.localized)!)
                self.remotePlayer?.actionAtItemEnd = .none
                if let item = self.remotePlayer?.currentItem {
                    self.remoteEndObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: .main) { [weak self] _ in
                        self?.playNext()
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.remoteAudioIsReady = true
                    if let currentItem = self?.remotePlayer?.currentItem {
                        self?.remoteAudioDuration = currentItem.duration
                    }
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.player = nil
                self?.currentTime = 0
                self?.isDownloaded = false
                self?.isPlaying = false
            }
            throw DownloadError.currentAudioNotFound
        }
    }

    // MARK: Auto-next helpers
    private func playNext() {
        guard let next = nextAudio() else {
            // нет следующего — остановим воспроизведение
            DispatchQueue.main.async { [weak self] in
                self?.stop()
            }
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.currentId = next.id
            self?.isPlaying = true
        }
    }

    // AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNext()
    }
    
    func downloadAudio() async throws {
        if let currentAudio = currentAudio(), let urlString = URL(string: currentAudio.downloadUrl.localized) {
            DispatchQueue.main.async { [weak self] in
                self?.isDownloading = true
            }
            let (url, _) = try await URLSession.shared.download(from: urlString)
            let data = try Data(contentsOf: url)
            LocalFileManager.shared.createFolderIfNeeded()
            _ = LocalFileManager.shared.saveAudio(data: data, name: currentAudio.title.localized)
            try await Task.sleep(nanoseconds: 100_000)
            DispatchQueue.main.async { [weak self] in
                self?.isDownloading = false
            }
            try self.getAudio()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.isDownloading = false
            }
            throw DownloadError.currentAudioNotFound
        }
    }
    
    @MainActor
    func setParams(id: UUID, type: AudioModel.AudioType) {
        self.currentId = id
        self.audioType = type
    }
    
    func currentAudio() -> AudioModel? {
        feed.first(where: { $0.id == currentId })
    }
    
    func getCurrentIndex() -> Int {
        if let idx = feed.firstIndex(where: {$0.id == self.currentId}) {
            return idx
        } else {
            return 0
        }
    }
    
    func getItemIndex(for item: AudioModel) -> Int {
        if let idx = feed.firstIndex(where: {$0.id == item.id}) {
            return idx
        } else {
            return 0
        }
    }
    
    func nextAudio() -> AudioModel? {
        let current = currentAudio()
        let idxOfCurrent = feed.firstIndex(where: {$0.id == current?.id})
        if let idxOfCurrent, idxOfCurrent < feed.count - 1 {
            return feed[idxOfCurrent + 1]
        } else {
            return nil
        }
    }
    
    func previous() -> AudioModel? {
        let current = currentAudio()
        let idxOfCurrent = feed.firstIndex(where: {$0.id == current?.id})
        if let idxOfCurrent, idxOfCurrent > 0 {
            return feed[idxOfCurrent - 1]
        } else {
            return nil
        }
    }
    
    func setupRemoteControl() {

        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            if let player = self.player {
                player.play()
                return .success
            }
            if let remotePlayer = self.remotePlayer {
                remotePlayer.play()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            if let player = self.player {
                player.stop()
                return .success
            }
            if let remotePlayer = self.remotePlayer {
                remotePlayer.pause()
                return .success
            }
            return .commandFailed
        }
    }
}

enum DownloadError: Error {
    case currentAudioNotFound
}

