//
//  MiniPlayerDetailControlView.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/10/25.
//

import SwiftUI

struct MiniPlayerDetailControlView: View {
    @EnvironmentObject var miniPlayerData: MiniPlayerData
    @StateObject private var controlData = MiniPlayerControlData()
    
    var body: some View {
        VStack(spacing: 16) {
            controlView
            playbackDurationView
            volumeControlView
        }
        .onAppear {
            controlData.sliderValue = miniPlayerData.nowPlayTime
        }
        .onChange(of: miniPlayerData.nowPlayingItem) { _ in
            controlData.sliderValue = miniPlayerData.nowPlayTime
        }
    }
    
    private var controlView: some View {
        HStack(spacing: 16) {
            CustomButton(
                action:{ await miniPlayerData.repeatMode() },
                imageName: miniPlayerData.repeatMode.image
            )
            CustomButton(
                action: { await miniPlayerData.skipToPreviousItem() },
                imageName: "backward.fill"
            )
            CustomButton(
                action: { await miniPlayerData.togglePlayback() },
                imageName: miniPlayerData.playbackStatus.buttonImage
            )
            CustomButton(
                action: { await miniPlayerData.skipToNextItem() },
                imageName: "forward.fill"
            )
            CustomButton(
                action: { await miniPlayerData.shufflePlay() },
                imageName: "shuffle"
            )
        }
    }
    
    @ViewBuilder
    private var playbackDurationView: some View {
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
                Text("\(formattedTime(timeInSeconds: controlData.sliderValue))")
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
    
    private var volumeControlView: some View {
        HStack {
            Image(systemName: "speaker.fill").foregroundColor(.white)
            Slider(
                value: Binding(
                    get: { Double(controlData.volume) },
                    set: { newValue in
                        controlData.volume = Float(newValue)
                        controlData.setSystemVolume(volume: Float(newValue))
                    }
                ),
                in: 0...1,
                step: 0.01
            )
            .accentColor(.white)
            Image(systemName: "speaker.wave.3.fill").foregroundColor(.white)
        }
        .padding(.top, 20)
    }
    
    private func formattedTime(timeInSeconds: TimeInterval) -> String {
        let minutes = Int(timeInSeconds) / 60
        let seconds = Int(timeInSeconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    MiniPlayerDetailControlView().environmentObject(MiniPlayerData())
}
