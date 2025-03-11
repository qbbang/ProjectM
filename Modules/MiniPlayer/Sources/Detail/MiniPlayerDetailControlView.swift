//
//  MiniPlayerDetailControlView.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/10/25.
//

import SwiftUI

struct MiniPlayerDetailControlView: View {
    @EnvironmentObject var miniPlayerData: MiniPlayerData
    
    var body: some View {
        VStack(spacing: 16) {
            controlView
            playbackDurationView
        }
    }
    
    private var controlView: some View {
        HStack(spacing: 16) {
            CustomButton(action: {
                await miniPlayerData.repeatMode()
            }, imageName: miniPlayerData.repeatMode.image)
            
            CustomButton(action: {
                await miniPlayerData.skipToPreviousItem()
                await miniPlayerData.sync()
            }, imageName: "backward.fill")
            
            CustomButton(action: {
                await miniPlayerData.togglePlayback()
            }, imageName: miniPlayerData.playbackStatus.buttonImage)
            
            CustomButton(action: {
                await miniPlayerData.skipToNextItem()
                await miniPlayerData.sync()
            }, imageName: "forward.fill")
            
            CustomButton(action: {
                await miniPlayerData.shufflePlay()
            }, imageName: "shuffle")
            
            #if DEBUG
            CustomButton(action: {
                await miniPlayerData.seek(to: 200)
            }, imageName: "arrow.trianglehead.2.clockwise.rotate.90.circle.fill")
            #endif
        }
    }
    
    private var playbackDurationView: some View {
        VStack {
            let total = miniPlayerData.nowPlayingItem?.playbackDuration ?? 0
            // TODO: seek 활용하려면 Slider로 처리해야함.
            // 노래가 끝나면 타이머도 종료되어야함
            ProgressView(value: miniPlayerData.nowPlayTime, total: total)
                .progressViewStyle(LinearProgressViewStyle())
            
            HStack {
                Text("\(formattedTime(timeInSeconds: miniPlayerData.nowPlayTime))")
                    .font(.caption)
                    .foregroundColor(.white)
                Spacer()
                Text("- \(formattedTime(timeInSeconds: miniPlayerData.nowPlayDuration))")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
    }
    
    private func formattedTime(timeInSeconds: TimeInterval) -> String {
        let minutes = Int(timeInSeconds) / 60
        let seconds = Int(timeInSeconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    MiniPlayerDetailControlView()
        .environmentObject(MiniPlayerData())
}
