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
   
    @MainActor
    func testPlay(album: MPMediaItemCollection) async {
        Task {
            await mediaPlayerService.replaceQueue(collection: album)
            await mediaPlayerService.play()
        }
    }
}

extension AlbumListData {
    static func placeHolder() -> AlbumListData {
        let mediaPlayerService = MediaPlayerService()
        let data = AlbumListData(mediaPlayerService: mediaPlayerService)
        return data
    }
}
