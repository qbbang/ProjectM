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
            testiew
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
    private var testiew: some View  {
        if mediaItem.isPlaying {
            Label(mediaItem.title, systemImage: "music.note")
                .foregroundStyle(.white)
                .font(.callout.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            HStack {
                //                let number =
                Text("\(mediaItem.positionl)")
                
                Text(mediaItem.title)
                    .foregroundStyle(.black)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
    }
}

//#Preview {
//    @Namespace var animation
//    let mediaItem = MediaItem(id: 12, title: "노래 제목", original: .init())
//
//    MediaItemTitleView(namespace: animation, mediaItem: mediaItem)
//}
