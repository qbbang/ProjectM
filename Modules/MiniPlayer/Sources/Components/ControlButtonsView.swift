//
//  ControlButtonsView.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/11/25.
//

import SwiftUI

struct ControlButtonsView: View {
    @EnvironmentObject var miniPlayerData: MiniPlayerData
    
    var body: some View {
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
}
