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
            ControlButtonsView()
                .environmentObject(miniPlayerData)
            PlaybackSliderView(controlData: controlData)
            VolumeControlView(controlData: controlData)
        }
        .onAppear {
            controlData.sliderValue = miniPlayerData.nowPlayTime
        }
        .onChange(of: miniPlayerData.nowPlayingItem) { _ in
            controlData.sliderValue = miniPlayerData.nowPlayTime
        }
    }
}

#Preview {
    MiniPlayerDetailControlView().environmentObject(MiniPlayerData())
}
