//
//  MusicPlayerContainerView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/10/25.
//

import SwiftUI
import MiniPlayer

struct MusicPlayerContainerView<Content: View>: View {
    @EnvironmentObject private var miniPlayerData: MiniPlayerData
    let content: Content
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .environmentObject(miniPlayerData)
            
            if miniPlayerData.isMediaItemsFetched {
                withAnimation {
                    MiniPlayerView()
                        .environmentObject(miniPlayerData)
                        .frame(height: miniPlayerData.miniPlayerHeight)
                        .task {
                            await miniPlayerData.sync()
                        }
                        .transition(.opacity)
                }
            }
        }
    }
}
