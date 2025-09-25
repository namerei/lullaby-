//
//  PlayerView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    @StateObject private var playerVM: PlayerViewModel = PlayerViewModel()
    @AppStorage("paid") private var paid: Bool = false
    @AppStorage("skipped_payment") private var skippedPayment: Bool = false
    @GestureState private var topDragOffset: CGSize = .zero
    @State private var isDraggingControl: Bool = false
    @State private var passedTimeWidth: CGFloat = 0
    @State private var isDraggingTop: Bool = false
    @State private var showSleepTimerSheet: Bool = false
    
    let id: UUID
    let type: AudioModel.AudioType
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                Top()
                Spacer()
                VStack {
                    if let current = playerVM.currentAudio() {
                        Descriptions(current: current)
                        Spacer()
                        if playerVM.playerIsReady == true {
                            Controls()
                        } else if playerVM.remoteAudioIsReady == true {
                            RemoteControls()
                        }
                    }
                }
                .frame(height: proxy.size.height/2.3)
            }
            .onAppear(perform: {
                navigationVM.tabBarHidden = true
                playerVM.setParams(id: id, type: type)
                playerVM.updateCurrentTime()
            })
            .background(Color.themeBackgroundDarker)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { ToolbarBack() }
                
                ToolbarItem(placement: .principal) { ToolbarTitle() }
                
                ToolbarItem(placement: .topBarTrailing) { ToolbarDownload() }
                ToolbarItem(placement: .topBarTrailing) { Spacer().frame(width: 10) }
                ToolbarItem(placement: .topBarTrailing) { ToolbarAirplay() }
            }
            .navigationBarBackButtonHidden()
            .toolbar(.hidden, for: .tabBar)
            .sheet(isPresented: $showSleepTimerSheet) {
                SleepTimerView(viewModel: playerVM)
                    .presentationDetents([.fraction(0.95)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    @ViewBuilder
    func Top() -> some View {
        ZStack {
            ForEach(playerVM.feed) { item in
                VStack {
                    Image(item.image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                        .padding(10)
                }
                .frame(width: 300, height: 300)
                .modifier(TopCardTransform(
                    index: playerVM.getItemIndex(for: item),
                    currentIndex: playerVM.getCurrentIndex(),
                    dragOffsetX: topDragOffset.width,
                    isDragging: isDraggingTop
                ))
            }
        }
        .gesture(
            DragGesture()
                .updating($topDragOffset, body: { value, state, transaction in
                    state = value.translation
                    if isDraggingTop == false { isDraggingTop = true }
                })
                .onEnded({ value in
                    let threshold: CGFloat = 50
                    if value.translation.width > threshold {
                        let currentIndex = playerVM.getCurrentIndex()
                        playerVM.currentId = playerVM.feed[max(currentIndex - 1, 0)].id
                    }
                    if value.translation.width < -threshold {
                        let currentIndex = playerVM.getCurrentIndex()
                        playerVM.currentId = playerVM.feed[min(currentIndex + 1, playerVM.feed.count - 1)].id
                    }
                    // trigger spring settle of cards back to position
                    isDraggingTop = false
                })
        )
    }

    // Smooth transform for top carousel cards
    struct TopCardTransform: ViewModifier {
        let index: Int
        let currentIndex: Int
        let dragOffsetX: CGFloat
        let isDragging: Bool

        func body(content: Content) -> some View {
            let baseOffset = CGFloat(index - currentIndex) * 300 + dragOffsetX
            let normalized = min(abs(baseOffset) / 300, 1)
            let scale = 1.1 - 0.2 * normalized    // 1.1 at center -> 0.9 on neighbor
            let opacity = 1.0 - 0.2 * normalized  // 1.0 at center -> 0.8 on neighbor
            return content
                .scaleEffect(scale)
                .opacity(opacity)
                .offset(x: baseOffset)
                .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.85, blendDuration: 0.1), value: isDragging)
        }
    }
    
    @ViewBuilder
    func Descriptions(current: AudioModel) -> some View {
        VStack {
            Text(current.title.localized)
                .customFont(.lg, size: 22)
                .fontWeight(.bold)
            Text(current.description.localized)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func RemoteControls() -> some View {
        VStack {
            HStack {
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2.0)
                            .fill(.secondary)
                            .frame(height: 3)
                        HStack(spacing: -5) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.primary)
                                .frame(height: 3)
                            Circle()
                                .fill(.primary)
                                .frame(width: isDraggingControl ? 24 : 8)
                        }
                        .frame(width: passedTimeWidth)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    if !isDraggingControl {
                                        isDraggingControl = true
                                    }
                                    passedTimeWidth = max(min(value.location.x, proxy.size.width), 0)
                                })
                                .onEnded({ value in
                                    let duration = playerVM.remoteAudioDuration.seconds.isNaN || playerVM.remoteAudioDuration.seconds.isInfinite ? 60.0 : playerVM.remoteAudioDuration.seconds
                                    if let remotePlayer = playerVM.remotePlayer {
                                        remotePlayer.seek(to: CMTime(seconds: (passedTimeWidth / proxy.size.width) * duration, preferredTimescale: .max), toleranceBefore: .zero, toleranceAfter: .zero)
                                    }
                                    isDraggingControl = false
                                })
                        )
                    }
                    .onChange(of: playerVM.remoteAudioCurrentTime, perform: { newValue in
                        let duration = playerVM.remoteAudioDuration.seconds.isNaN || playerVM.remoteAudioDuration.seconds.isInfinite ? 60.0 : playerVM.remoteAudioDuration.seconds
                        if isDraggingControl == false {
                            passedTimeWidth = newValue.seconds * proxy.size.width / duration
                        }
                    })
                }
            }
            .frame(height: 15)
            HStack {
                Text("\(Utils.shared.timeString(time: TimeInterval(playerVM.remoteAudioCurrentTime.seconds)))")
                Spacer()
                Text("\(Utils.shared.timeString(time: TimeInterval(playerVM.remoteAudioDuration.seconds)))")
            }
            .font(.callout)
            .foregroundStyle(.secondary)
            HStack {
                //заглушка
                playFromStartButton(active: playerVM.remoteAudioIsPlaying)
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    playerVM.back15()
                }, label: {
                    Image(.back15Icon)
                })
                .frame(maxWidth: .infinity)
                Button(action: {
                    if paid == true || playerVM.getCurrentIndex() == 0 {
                        if playerVM.remoteAudioIsPlaying == true {
                            playerVM.stop()
                        } else {
                            playerVM.play()
                        }
                    } else {
                        skippedPayment = false
                    }
                }, label: {
                    if playerVM.remoteAudioIsPlaying == true {
                        Image(.stopIcon)
                    } else {
                        Image(.playIcon)
                    }
                })
                .frame(maxWidth: .infinity)
                Button(action: {
                    playerVM.forward30()
                }, label: {
                    Image(.forward30Icon)
                })
                .offset(y: 4)
                .frame(maxWidth: .infinity)
                
                TimerButton()
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical)
        }
        .padding()
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func Controls() -> some View {
        VStack {
            HStack {
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2.0)
                            .fill(.secondary)
                            .frame(height: 3)
                        HStack(spacing: -5) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.primary)
                                .frame(height: 3)
                            Circle()
                                .fill(.primary)
                                .frame(width: isDraggingControl ? 24 : 8)
                        }
                        .frame(width: passedTimeWidth)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    if !isDraggingControl {
                                        isDraggingControl = true
                                    }
                                    passedTimeWidth = max(min(value.location.x, proxy.size.width), 0)
                                })
                                .onEnded({ value in
                                    playerVM.currentTime = (passedTimeWidth / proxy.size.width) * playerVM.audioDuration
                                    isDraggingControl = false
                                })
                        )
                    }
                    .onChange(of: playerVM.currentTime, perform: { newValue in
                        if isDraggingControl == false {
                            passedTimeWidth = (newValue * proxy.size.width) / playerVM.audioDuration
                        }
                    })
                }
            }
            .frame(height: 15)
            HStack {
                Text("\(Utils.shared.timeString(time: playerVM.currentTime))")
                Spacer()
                Text("\(Utils.shared.timeString(time: playerVM.audioDuration))")
            }
            .font(.callout)
            .foregroundStyle(.secondary)
            
            bottomButtonsSection
            .padding(.vertical)
        }
        .padding()
        .padding(.horizontal)
    }
    
    
    @MainActor
    var bottomButtonsSection: some View {
        HStack {
            //заглушка
//                TimerButton()
//                    .frame(maxWidth: .infinity)
//                Spacer()
//                TimerButton()
//                    .frame(maxWidth: 60)
//            Text("her")
            
            playFromStartButton(active: playerVM.isPlaying)
                .frame(maxWidth: .infinity)

            Button(action: {
                playerVM.back15()
            }, label: {
                Image(.back15Icon)
            })
            .frame(maxWidth: .infinity)
            
            Button(action: {
                if paid == true || playerVM.getCurrentIndex() == 0 {
                    if playerVM.isPlaying == true {
                        playerVM.stop()
                    } else {
                        playerVM.play()
                    }
                } else {
                    skippedPayment = false
                }
            }, label: {
                if playerVM.isPlaying == true {
                    Image(.stopIcon)
                } else {
                    Image(.playIcon)
                }
            })
            .frame(maxWidth: .infinity)
            
            Button(action: {
                playerVM.forward30()
            }, label: {
                Image(.forward30Icon)
            })
            .offset(y: 4)
            .frame(maxWidth: .infinity)
            
            TimerButton()
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: Toolbar Items...
    @ViewBuilder
    func ToolbarDownload() -> some View {
        if playerVM.isDownloaded == false {
            if playerVM.isDownloading == true {
                ProgressView()
            } else {
                Image(.downloadIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        Task {
                            do {
                                try await playerVM.downloadAudio()
                            } catch {
                                print(error)
                            }
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    func ToolbarAirplay() -> some View {
        AirPlayButton().frame(width: 24, height: 24)
    }
    
    @ViewBuilder
    func ToolbarTitle() -> some View {
        HStack {
            Text("Now playing".localized)
                .font(Font(.init(.label, size: 17)))
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func ToolbarBack() -> some View {
        Button(action: {
            playerVM.remotePlayer = nil
            playerVM.player = nil
            playerVM.cancelSleepTimer()
            _ = navigationVM.navigationPath.popLast()
        }, label: {
            Image(systemName: "chevron.left")
                .font(.headline)
        })
        .foregroundStyle(.primary)
    }

    @ViewBuilder
    func TimerButton() -> some View {
        Button(action: {
            showSleepTimerSheet = true
        }, label: {
            VStack(spacing: 2) {
                Image("moon_zzz")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                if playerVM.sleepTimerIsActive {
                    Text(Utils.shared.timeString(time: max(0, playerVM.sleepRemainingSeconds)))
                        .font(.caption2)
                }
            }
        })
        .foregroundStyle(playerVM.sleepTimerIsActive ? .primary : .secondary)
    }
    
    @ViewBuilder
    func playFromStartButton(active: Bool) -> some View {
        Button(action: {
            playerVM.restartFromBeginning()
        }, label: {
            Image("Frame 77")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        })
        .foregroundStyle(active ? .primary : .secondary)
    }
}

#Preview {
    NavigationStack {
        PlayerView(id: LocalData.shared.allAudios[0].id, type: .melody)
            .preferredColorScheme(.dark)
    }
}
