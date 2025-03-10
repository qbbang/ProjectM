//
//  MiniPlayerView.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/9/25.
//

import SwiftUI

public struct MiniPlayerView: View {
    @EnvironmentObject public var miniPlayerData: MiniPlayerData
    @State private var isModalPresented = false
    
    public init() { }
    
    public var body: some View {
        contentView.onTapGesture {
            isModalPresented = true
        }
    }
    
    var contentView: some View {
        HStack {
            playPauseButton
            infoView
            artworkImageView
        }
        .padding(.horizontal, 16)
        .background(Color.black.opacity(0.9))
        .cornerRadius(16)
        .sheet(isPresented: $isModalPresented) {
            if #available(iOS 16.0, *) {
                MiniPlayerDetailView()
                    .environmentObject(miniPlayerData)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            } else {
                MiniPlayerDetailView()
                    .environmentObject(miniPlayerData)
            }
        }
    }
    
    private var playPauseButton: some View {
        Button(action: {
            Task {
                await miniPlayerData.togglePlayback()
            }
        }) {
            Image(systemName: miniPlayerData.playbackStatus.buttonImage)
                .resizable()
                .frame(width: 24, height: 24)
                .tint(Color.black)
        }
        .frame(width: 50, height: 50)
        .background(Color.white)
        .cornerRadius(16)
    }
    
    private var infoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(miniPlayerData.title)
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(miniPlayerData.artistName)
                .font(.caption)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: miniPlayerData.miniPlayerHeight, alignment: .center)
    }
    
    @ViewBuilder
    private var artworkImageView: some View {
        if let artworkImage = miniPlayerData.artwork {
            artworkImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(8)
        } else {
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 50, height: 50)
                .cornerRadius(8)
        }
    }
}

#Preview {
    MiniPlayerView()
        .frame(height: 80)
}
