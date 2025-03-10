//
//  MiniPlayerDetailView.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/10/25.
//

import SwiftUI

struct MiniPlayerDetailView: View {
    @EnvironmentObject var miniPlayerData: MiniPlayerData
    
    var body: some View {
        VStack(spacing: 16) {
            infoView
                .padding(.top, 64)
            
            artworkView
                .padding(.horizontal, 32)
            
            MiniPlayerDetailControlView()
                .environmentObject(miniPlayerData)
                .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.9))
        
    }
    
    var infoView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(miniPlayerData.title)
                .font(.subheadline.bold())
                .foregroundColor(.black)
            
            Text(miniPlayerData.artistName)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    @ViewBuilder
    var artworkView: some View {
        if let artwork = miniPlayerData.artwork {
            artwork
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .cornerRadius(8)
        }
    }
    
}

#Preview {
    MiniPlayerDetailView()
        .environmentObject(MiniPlayerData())
}
