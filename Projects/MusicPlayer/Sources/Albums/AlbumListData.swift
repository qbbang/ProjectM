//
//  AlbumListData.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/7/25.
//

import Foundation
@preconcurrency import MediaPlayer
import MediaPlayerService

final class AlbumListData: ObservableObject {
    let mediaPlayerService: MediaPlayerServiceable
    
    @Published var albums: [MPMediaItem] = []
    
    init(mediaPlayerService: MediaPlayerServiceable) {
        self.mediaPlayerService = mediaPlayerService
    }
    
    @MainActor
    func fetchMediaItems() async {
        let items = await Task {
            await mediaPlayerService.fetchMediaQuery(for: .albums())
        }.value
        
        self.albums = items
    }
}
