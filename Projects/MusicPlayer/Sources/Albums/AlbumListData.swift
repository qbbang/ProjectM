//
//  AlbumListData.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/7/25.
//

import Foundation
import MediaPlayerService

final class AlbumListData: ObservableObject {
    @Published var albums: [MediaItemCollection] = []
    
    @MainActor
    @discardableResult
    func fetchAlbumList() async -> [MediaItemCollection] {
        self.albums = await MediaPlayerService.shared.fetchAlbumDisplayItems()
        return self.albums
    }
}

extension AlbumListData {
    static func mock() -> AlbumListData {
        let data = AlbumListData()
        data.albums = [
            MediaItemCollection(title: "Album 1", artist: "Artist 1", artwork: nil, items: []),
            MediaItemCollection(title: "Album 2", artist: "Artist 2", artwork: nil, items: []),
            MediaItemCollection(title: "Album 3", artist: "Artist 3", artwork: nil, items: []),
            MediaItemCollection(title: "Album 4", artist: "Artist 4", artwork: nil, items: []),
            MediaItemCollection(title: "Album 5", artist: "Artist 5", artwork: nil, items: []),
            MediaItemCollection(title: "Album 6", artist: "Artist 6", artwork: nil, items: []),
            MediaItemCollection(title: "Album 7", artist: "Artist 7", artwork: nil, items: []),
            MediaItemCollection(title: "Album 8", artist: "Artist 8", artwork: nil, items: []),
        ]
        
        return data
    }
}
