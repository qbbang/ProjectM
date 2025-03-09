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
    
    @Published var soungs: [MediaItem] = []
    
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
        
        soungs = album.items
    }
    
    @MainActor
    func play() async {
        Task {
            await mediaPlayerService.replaceQueue(items: soungs)
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
        var shuffleSoungs = soungs
        shuffleSoungs.shuffle()
        soungs = shuffleSoungs
        
        Task {
            await mediaPlayerService.shuffle(items: shuffleSoungs)
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
                items: []
            )
        )
        return data
    }
}
