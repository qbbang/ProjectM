//
//  PlaybackSliderView.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/11/25.
//

import SwiftUI

struct PlaybackSliderView: View {
    @EnvironmentObject var miniPlayerData: MiniPlayerData
    @ObservedObject var controlData: MiniPlayerControlData
    
    var body: some View {
        let total = miniPlayerData.nowPlayingItem?.playbackDuration ?? 0
        VStack {
            Slider(
                value: Binding(
                    get: { controlData.sliderValue },
                    set: { controlData.sliderValue = $0 }
                ),
                in: 0...max(1, total),
                step: 1
            ) { editing in
                controlData.isDragging = editing
                if !editing {
                    controlData.isSeeking = true
                    Task {
                        await miniPlayerData.seek(to: controlData.sliderValue)
                        await MainActor.run {
                            controlData.isSeeking = false
                            controlData.sliderValue = miniPlayerData.nowPlayTime
                        }
                    }
                }
            }
            .accentColor(.white)
            
            HStack {
                Text(formattedTime(timeInSeconds: controlData.sliderValue))
                    .font(.caption)
                    .foregroundColor(.white)
                Spacer()
                Text("- \(formattedTime(timeInSeconds: max(0, total - controlData.sliderValue)))")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .onReceive(miniPlayerData.$nowPlayTime) { newTime in
            if !controlData.isDragging && !controlData.isSeeking {
                controlData.sliderValue = newTime
            }
        }
    }
}

extension PlaybackSliderView {
    private func formattedTime(timeInSeconds: TimeInterval) -> String {
        let minutes = Int(timeInSeconds) / 60
        let seconds = Int(timeInSeconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
