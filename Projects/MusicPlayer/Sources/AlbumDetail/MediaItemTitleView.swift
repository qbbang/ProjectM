//
//  SoungTitleView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/9/25.
//

import SwiftUI
import MediaPlayerService

struct MediaItemTitleView: View {
    let mediaItem: MediaItem
    
    var body: some View {
        Label(mediaItem.title, systemImage: "music.note")
        
    }
}

#Preview {
    let mediaItem = MediaItem(id: 12, title: "노래 제목", original: .init())
    MediaItemTitleView(mediaItem: mediaItem)
}
