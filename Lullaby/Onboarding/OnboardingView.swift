//
//  OnboardingView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 05/12/23.
//

import SwiftUI
import AVKit

struct OnboardingView: View {
    @State private var onboardingSelection: OnboardingSelectionItem = .first
    @AppStorage("onboarding") private var onboarding: Bool = true
    @State private var player: AVPlayer = AVPlayer()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LoopingVideoBackground(player: player)
                .ignoresSafeArea()
            
            VStack {
                HStack(spacing: 10) {
                    ForEach(OnboardingSelectionItem.allCases, id: \.hashValue) { selection in
                        Circle()
                            .fill(selection == onboardingSelection ? Color.white : Color.secondary)
                            .frame(width: 5, height: 5)
                    }
                }
                .padding()
                Text(onboardingSelection.text)
                    .multilineTextAlignment(.leading)
                    .customFont(.md, size: 20)
                    .padding(.horizontal)
                Button(action: {
                    if onboardingSelection == .third {
                        onboarding = false
                    } else {
                        onboardingSelection = onboardingSelection.next
                        loadVideo(video: onboardingSelection.video)
                    }
                }, label: {
                    Text("Next".localized)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .font(.headline)
                        .background(
                            RoundedRectangle(cornerRadius: 16.0)
                                .fill(.ultraThinMaterial)
                        )
                        .padding()
                })
                .foregroundStyle(.primary)
            }
            .background {
                Rectangle()
                    .fill(LinearGradient(colors: [.clear, .themeBackgroundDarker, .themeBackgroundDarker], startPoint: .top, endPoint: .bottom))
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            loadVideo(video: onboardingSelection.video)
        }
    }
    
    @ViewBuilder
    private func BackgroundView() -> some View {
        
    }
    
    private func loadVideo(video: String) {
        guard let url = Bundle.main.url(forResource: video, withExtension: "mp4") else {
            print("Video file not found: \(video)")
            return
        }
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.isMuted = true
        player.actionAtItemEnd = .none
        
        // Loop the video
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
        player.play()
    }
}

#Preview {
    OnboardingView()
        .preferredColorScheme(.dark)
}
