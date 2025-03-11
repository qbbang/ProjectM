//
//  SoungTitleView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/9/25.
//

import SwiftUI
import MediaPlayerService

struct MediaItemTitleView: View {
    let namespace: Namespace.ID
    let mediaItem: MediaItem
    
    var body: some View {
        ZStack {
            highlightView
            titleView
        }
        
    }
    
    @ViewBuilder
    private var highlightView: some View  {
        if mediaItem.isPlaying {
            Color.black
                .matchedGeometryEffect(id: "\(#file)", in: namespace)
            
        }
    }
    
    @ViewBuilder
    private var titleView: some View  {
        if mediaItem.isPlaying {
            Label(mediaItem.title, systemImage: "music.note")
                .foregroundStyle(.white)
                .font(.callout.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            HStack {
                Text("\(mediaItem.positionl)")
                Text(mediaItem.title)
                    .foregroundStyle(.black)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    @Namespace var animation
    let mediaItem = MediaItem(
        id: 231,
        title: "title",
        artist: "artist",
        artwork: nil,
        playbackDuration: 180,
        isPlaying: true,
        positionl: 0,
        original: .init()
    )
    
    MediaItemTitleView(namespace: animation, mediaItem: mediaItem)
}
