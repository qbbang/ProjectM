//
//  AlbumListData.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/7/25.
//

import Foundation
import MediaPlayerService
import MediaPlayer

final class AlbumListData: ObservableObject {
    let mediaPlayerService: MediaPlayerServiceable
    
    @Published var albums: [AlbumDisplayItem] = []
    
    init(mediaPlayerService: MediaPlayerServiceable) {
        self.mediaPlayerService = mediaPlayerService
    }
    
    @MainActor
    func fetchMediaItems() async {
        let items = await Task {
            await mediaPlayerService.fetchAlbumDisplayItems()
        }.value
        
        self.albums = items
    }
}

extension AlbumListData {
    static func mock() -> AlbumListData {
        let data = AlbumListData(mediaPlayerService: MediaPlayerService())
        data.albums = [
            AlbumDisplayItem(title: "Album 1", artist: "Artist 1", artwork: nil, mediaItemCollection: MPMediaItemCollection(items: [])),
            AlbumDisplayItem(title: "Album 2", artist: "Artist 2", artwork: nil, mediaItemCollection: MPMediaItemCollection(items: [])),
            AlbumDisplayItem(title: "Album 3", artist: "Artist 3", artwork: nil, mediaItemCollection: MPMediaItemCollection(items: [])),
            AlbumDisplayItem(title: "Album 4", artist: "Artist 4", artwork: nil, mediaItemCollection: MPMediaItemCollection(items: [])),
            AlbumDisplayItem(title: "Album 5", artist: "Artist 5", artwork: nil, mediaItemCollection: MPMediaItemCollection(items: [])),
            AlbumDisplayItem(title: "Album 6", artist: "Artist 6", artwork: nil, mediaItemCollection: MPMediaItemCollection(items: [])),
            AlbumDisplayItem(title: "Album 7", artist: "Artist 7", artwork: nil, mediaItemCollection: MPMediaItemCollection(items: [])),
            AlbumDisplayItem(title: "Album 8", artist: "Artist 8", artwork: nil, mediaItemCollection: MPMediaItemCollection(items: []))
        ]
        
        return data
    }
}
