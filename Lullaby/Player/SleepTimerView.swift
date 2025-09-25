//
//  SleepTimerView.swift
//  Lullaby
//
//  Created by Assistant on 24/09/25.
//

import SwiftUI

struct SleepTimerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PlayerViewModel

    // minutes range 1...60
    @State private var selectedMinutes: Int = 15
    @State private var angle: Angle = .degrees(0)
    @State private var isPressingHandle: Bool = false
    private let accent = Color("BaseOrange")

    var body: some View {
        ZStack {
            Color.themeBackgroundDarker.ignoresSafeArea(.all)
//            VStack(spacing: 24) {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            ZStack {
                                Circle()
                                    .frame(width: 26)
                                    .tint(.gray.opacity(0.24))
//                                    .background(Color.gray.opacity(0.4))
                                Image(systemName: "xmark")
                                    .font(.headline)
                                    .padding(8)
                                    .contentShape(Rectangle())
                                    .foregroundStyle(Color.white.opacity(0.5))
                                    .fontWeight(.semibold)
                                    .scaleEffect(0.7)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Text("Sleep Timer")
                        .customFont(.xl, size: 34)
                        .fontWeight(.bold)
                    
                    Toggle(isOn: $viewModel.sleepUntilEndOfTrack) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Now playing")
                                .font(.system(size: 18)).fontWeight(.semibold)
                        }
                    }
                    .tint(accent)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
//                .background(Color.orange)
                
                
                VStack {
                    Spacer()
                    ZStack {
                        let ringWidth: CGFloat = 6
                        let circleSize: CGFloat = 240
                        Circle()
                            .stroke(Color.secondary.opacity(0.25), lineWidth: ringWidth)
                            .frame(width: circleSize, height: circleSize)
                        
                        // progress arc
                        Circle()
                            .trim(from: 0, to: CGFloat(Double(selectedMinutes) / 60.0))
                            .stroke(accent, style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: circleSize, height: circleSize)
                        
                        // handle halo when pressing
                        if isPressingHandle {
                            GeometryReader { geo in
                                let size = min(geo.size.width, geo.size.height)
                                let center = CGSize(width: size / 2, height: size / 2)
                                let r = size / 2 - ringWidth / 2
                                let progress = Double(selectedMinutes) / 60.0
                                let theta = 2 * Double.pi * progress - Double.pi / 2
                                let x = center.width + r * cos(theta)
                                let y = center.height + r * sin(theta)
                                Circle()
                                    .fill(accent.opacity(0.25))
                                    .frame(width: 36, height: 36)
                                    .position(x: x, y: y)
                            }
                            .frame(width: circleSize + 8, height: circleSize + 8)
                        }
                        
                        GeometryReader { geo in
                            let size = min(geo.size.width, geo.size.height)
                            let center = CGSize(width: size / 2, height: size / 2)
                            let r = size / 2 - ringWidth / 2
                            let progress = Double(selectedMinutes) / 60.0
                            let theta = 2 * Double.pi * progress - Double.pi / 2
                            let x = center.width + r * cos(theta)
                            let y = center.height + r * sin(theta)
                            Circle()
                                .fill(accent)
                                .frame(width: 16, height: 16)
                                .position(x: x, y: y)
                        }
                        .frame(width: circleSize + 7.5, height: circleSize + 7.5)
                        
                        // center label
                        VStack(spacing: 4) {
                            if viewModel.sleepTimerIsActive {
                                Text("\(Utils.shared.timeString(time: max(0, viewModel.sleepRemainingSeconds)))")
                                    .customFont(.lg, size: 34)
                                    .fontWeight(.bold)
                                Text("Remaining")
                                    .customFont(.lg, size: 18)
                                    .foregroundStyle(.white.opacity(0.8))
                            } else {
                                Text("\(selectedMinutes)")
                                    .customFont(.lg, size: 34)
                                    .fontWeight(.bold)
                                Text("Minutes")
                                    .customFont(.lg, size: 18)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                    }
//                    .background(Color.red)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if isPressingHandle == false { isPressingHandle = true }
                                let center = CGPoint(x: 120, y: 120)
                                let dx = value.location.x - center.x
                                let dy = value.location.y - center.y
                                let angle = atan2(dy, dx) + .pi / 2
                                var progress = angle / (2 * .pi)
                                if progress < 0 { progress += 1 }
                                let mins = Int(round(progress * 60))
                                let clamped = min(max(mins, 1), 60)
                                selectedMinutes = clamped
                                if viewModel.sleepTimerIsActive {
                                    viewModel.sleepRemainingSeconds = min(3600, Double(clamped * 60))
                                }
                            }
                            .onEnded { _ in
                                isPressingHandle = false
                            }
                    )
                    Spacer()
                }
                .offset(y: 30)

                
                VStack(spacing: 12) {
                    Spacer()
                    
                    if viewModel.sleepUntilEndOfTrack == false {
                        // обычный режим таймера
                    }
                    if viewModel.sleepTimerIsActive {
                        Button {
                            viewModel.cancelSleepTimer()
                            dismiss()
                        } label: {
                            Text("Stop")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(accent))
                                .foregroundStyle(Color.white)
                        }
                    } else {
                        Button {
                            if viewModel.sleepUntilEndOfTrack {
                                // В режиме до конца трека не запускаем обычный таймер
                                viewModel.sleepTimerIsActive = true
                                viewModel.sleepRemainingSeconds = 0
                            } else {
                                viewModel.startSleepTimer(totalSeconds: TimeInterval(selectedMinutes * 60))
                            }
                            dismiss()
                        } label: {
                            Text("Start")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(accent))
                                .foregroundStyle(Color.white)
                        }
                    }
                }
                .padding(.horizontal, 50)
//                .offset(y: 30)
            }
//        }
        
        .onAppear {
            // prefill from remaining if active
            if viewModel.sleepTimerIsActive {
                selectedMinutes = max(1, min(60, Int(ceil(viewModel.sleepRemainingSeconds / 60))))
            }
        }
    }
}

#Preview {
    SleepTimerView(viewModel: PlayerViewModel())
        .preferredColorScheme(.dark)
}


