//
//  ActionButtonView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/8/25.
//

import SwiftUI

struct ActionButtonView: View {
    let width: CGFloat
    var buttonImage: String
    
    var onPlayPauseToggle: () async -> Void
    var onShuffle: () async -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                Task { await onPlayPauseToggle() }
            }) {
                Image(systemName: buttonImage)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .tint(Color.black)
            }
            .frame(width: width, height: 60)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(16)
            
            Button(action: {
                Task { await onShuffle() }
            }) {
                Image(systemName: "shuffle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .tint(Color.black)
            }
            .frame(width: width, height: 60)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(16)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    ActionButtonView(
        width: UIScreen.main.bounds.width / 2,
        buttonImage: "play.fill") {
            print("onPlayPauseToggle")
        } onShuffle: {
            print("onShuffle")
        }
}
