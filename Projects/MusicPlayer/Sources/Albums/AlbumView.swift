//
//  AlbumView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/7/25.
//

import SwiftUI
import MediaPlayer

struct AlbumView: View {
    let album: MPMediaItem
    let geometry: GeometryProxy
    
    var body: some View {
        let width = (geometry.size.width / 2) - 16
        VStack(alignment: .leading, spacing: 8) {
            artworkImageView
            infoView
        }
        .frame(width: width)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }
    
    // MARK: Private
    @ViewBuilder
    private var artworkImageView: some View {
        let width = (geometry.size.width / 2) - 16
        
        AsyncImage(url: nil) { image in
            if let artworkImage = album.artwork?.image(at: CGSize(width: width, height: width)) {
                Image(uiImage: artworkImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: width)
            } else {
                Color.gray
                    .frame(width: width, height: width)
            }
        }
    }
    
    @ViewBuilder
    private var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(album.title ?? "Unknown")
                .font(.system(size: 14, weight: .bold))
                .lineLimit(1)
            Text(album.artist ?? "Noname")
                .font(.system(size: 12))
                .lineLimit(1)
        }
        .frame(height: 40, alignment: .topLeading)
        .padding(.horizontal, 16)
    }
}
