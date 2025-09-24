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
    @State private var selectedMinutes: Int = 30
    @State private var angle: Angle = .degrees(0)

    var body: some View {
        VStack(spacing: 24) {
            Text("Sleep Timer")
                .font(.title2)
                .fontWeight(.semibold)

            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 16)
                    .frame(width: 240, height: 240)

                // progress arc
                Circle()
                    .trim(from: 0, to: CGFloat(Double(selectedMinutes) / 60.0))
                    .stroke(Color.primary, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 240, height: 240)

                // hidden handle (no visible knob)

                // center label
                VStack(spacing: 4) {
                    Text("Minutes")
                        .foregroundStyle(.secondary)
                    Text("\(selectedMinutes)")
                        .font(.system(size: 48, weight: .bold))
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let center = CGPoint(x: 120, y: 120)
                        let dx = value.location.x - center.x
                        let dy = value.location.y - center.y
                        let angle = atan2(dy, dx) + .pi / 2
                        var progress = angle / (2 * .pi)
                        if progress < 0 { progress += 1 }
                        let mins = Int(round(progress * 60))
                        selectedMinutes = min(max(mins, 1), 60)
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
                    Text("Start Timer")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.primary))
                        .foregroundStyle(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .background(Color.yellow)
                }
                .padding()

                if viewModel.sleepTimerIsActive {
                    Button {
                        viewModel.cancelSleepTimer()
                        dismiss()
                    } label: {
                        Text("Cancel")
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


