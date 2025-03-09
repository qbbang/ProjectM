//
//  AlbumDetailData.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/8/25.
//

import SwiftUI

import MediaPlayerService

final class AlbumDetailData: ObservableObject {
    private let mediaPlayerService: MediaPlayerServiceable
    private let album: MediaItemCollection
    
    @Published var mediaItems: [MediaItem] = []
    
    var title: String {
        album.title
    }
    
    var artwork: Image? {
        album.artwork
    }
    
    var artistName: String {
        album.artist
    }
    
    init(mediaPlayerService: MediaPlayerServiceable, album: MediaItemCollection) {
        self.mediaPlayerService = mediaPlayerService
        self.album = album
        
        mediaItems = album.items
    }
    
    @MainActor
    func play() async {
        Task {
            await mediaPlayerService.replaceQueue(items: mediaItems)
            await mediaPlayerService.play()
        }
    }
    
    @MainActor
    func pause() async {
        Task {
            await mediaPlayerService.pause()
        }
    }
    
    @MainActor
    func shuffle() async {
        var shuffleMediaItems = mediaItems
        shuffleMediaItems.shuffle()
        mediaItems = shuffleMediaItems
        
        Task {
            await mediaPlayerService.shuffle(items: shuffleMediaItems)
        }
    }
    
    @MainActor
    func play(mediaItem: MediaItem) async {
        Task {
            await mediaPlayerService.play(mediaItem, in: mediaItems)
        }
    }
}

extension AlbumDetailData {
    static func mock() -> AlbumDetailData {
        let data = AlbumDetailData(
            mediaPlayerService: MediaPlayerService(),
            album: MediaItemCollection(
                title: "Album",
                artist: "Artist",
                artwork: nil,
                items: [
                    MediaItem(id: 123,
                              title: "내가 제일 잘 나가",
                              original: .init()
                             ),
                    MediaItem(id: 234,
                              title: "밤바라빠 빠빠빠빠빠빠 ",
                              original: .init()
                             ),
                    MediaItem(id: 345,
                              title: "누가 봐도 내가 좀 죽여주잖아",
                              original: .init()
                             ),
                    MediaItem(id: 456,
                              title: "타이틀",
                              original: .init()
                             ),
                    MediaItem(id: 567,
                              title: "무제",
                              original: .init()
                             )
                ]
            )
        )
        return data
    }
}
