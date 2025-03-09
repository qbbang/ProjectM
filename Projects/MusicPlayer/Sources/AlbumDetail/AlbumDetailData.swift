//
//  AlbumDetailData.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/8/25.
//

import SwiftUI

import MediaPlayerService
import MediaPlayer

final class AlbumDetailData: ObservableObject {
    let mediaPlayerService: MediaPlayerServiceable
    private let album: AlbumDisplayItem
    
    @Published var soungs: [MPMediaItem] = []
    
    var title: String {
        album.title
    }
    
    var artwork: Image? {
        album.artwork
    }
    
    var artistName: String {
        album.artist
    }
    
    init(mediaPlayerService: MediaPlayerServiceable, album: AlbumDisplayItem) {
        self.mediaPlayerService = mediaPlayerService
        self.album = album
        
        soungs = album.mediaItemCollection.items
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
            album: AlbumDisplayItem(
                title: "Album",
                artist: "Artist",
                artwork: nil,
                mediaItemCollection: .init(items: [])
            )
        )
        return data
    }
}
