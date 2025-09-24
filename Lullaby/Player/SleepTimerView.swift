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
    @State private var selectedMinutes: Int = 5
    @State private var angle: Angle = .degrees(0)
    @State private var isPressingHandle: Bool = false
    private let accent = Color("BaseOrange")

    var body: some View {
        VStack(spacing: 24) {
            Text("Sleep Timer")
                .offset(y: -30)
                .customFont(.xl, size: 30)
                .fontWeight(.bold)

            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.25), lineWidth: 8)
                    .frame(width: 240, height: 240)

                // progress arc
                Circle()
                    .trim(from: 0, to: CGFloat(Double(selectedMinutes) / 60.0))
                    .stroke(accent, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 240, height: 240)

                // handle halo when pressing
                if isPressingHandle {
                    GeometryReader { geo in
                        let size = min(geo.size.width, geo.size.height)
                        let radius = size / 2
                        let progress = Double(selectedMinutes) / 60.0
                        let theta = 2 * Double.pi * progress - Double.pi / 2
                        let x = radius + (radius - 8) * cos(theta)
                        let y = radius + (radius - 8) * sin(theta)
                        Circle()
                            .fill(accent.opacity(0.25))
                            .frame(width: 34, height: 34)
                            .position(x: x, y: y)
                    }
                    .frame(width: 240, height: 240)
                }
                
                GeometryReader { geo in
                    let size = min(geo.size.width, geo.size.height)
                    let radius = size / 2
                    let progress = Double(selectedMinutes) / 60.0
                    let theta = 2 * Double.pi * progress - Double.pi / 2
                    let x = radius + (radius - 8) * cos(theta)
                    let y = radius + (radius - 8) * sin(theta)
                    
                    Circle()
                        .fill(accent)
                        .frame(width: 1, height: 1)
                        .position(x: x, y: y)
                        .scaleEffect(20)
                    
                }
                .frame(width: 240, height: 240)

                // center label
                VStack(spacing: 4) {
                    Text("\(selectedMinutes)")
                        .customFont(.lg, size: 30)
                        .fontWeight(.bold)
                    Text("Minutes")
                        .customFont(.lg, size: 22)
                        .foregroundStyle(.secondary)
                }
            }
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
                        selectedMinutes = min(max(mins, 1), 60)
                    }
                    .onEnded { _ in
                        isPressingHandle = false
                    }
            )

            // quick presets (limited to 60m)
//            HStack(spacing: 12) {
//                ForEach([10, 20, 30, 45, 60], id: \.self) { m in
//                    Button(action: { selectedMinutes = m }) {
//                        Text("\(m) m")
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 8)
//                            .background(
//                                Capsule().fill(m == selectedMinutes ? Color.primary.opacity(0.15) : Color.secondary.opacity(0.15))
//                            )
//                    }
//                }
//            }

            VStack(spacing: 12) {
                Button {
                    viewModel.startSleepTimer(totalSeconds: TimeInterval(selectedMinutes * 60))
                    dismiss()
                } label: {
                    Text("Start")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(accent))
                        .foregroundStyle(Color.black)
                }
                .padding()

                if viewModel.sleepTimerIsActive {
                    Button {
                        viewModel.cancelSleepTimer()
                        dismiss()
                    } label: {
                        Text("Stop")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.primary))
                    }
                }
            }
        }
        .padding()
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


