//
//  AlbumView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/7/25.
//

import SwiftUI
import MediaPlayerService

struct AlbumView: View {
    let album: MediaItemCollection
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
        if let artworkImage = album.artwork {
            artworkImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: width)
                .clipped()
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: width, height: width)
        }
    }
    
    private var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(album.title)
                .font(.system(size: 14, weight: .bold))
                .lineLimit(1)
            Text(album.artist)
                .font(.system(size: 12))
                .lineLimit(1)
        }
        .frame(height: 40, alignment: .topLeading)
        .padding(.horizontal, 16)
    }
}

#Preview {
    GeometryReader { geometry in
        AlbumView(
            album: MediaItemCollection(
                title: "title",
                artist: "artist",
                artwork: Image("dpad.left.filled"),
                items: .init()
            ),
            geometry: geometry
        )
        .padding()
    }
    .frame(height: 200)
}
