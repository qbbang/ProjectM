//
//  AlbumDetailData.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/8/25.
//

import SwiftUI
import MediaPlayerService

final class AlbumDetailData: ObservableObject {
    let album: MediaItemCollection
    @Published var mediaItems: [MediaItem] = []
    
    var title: String { album.title }
    var artwork: Image? { album.artwork }
    var artistName: String { album.artist }
    
    init(album: MediaItemCollection) {
        self.album = album
        mediaItems = album.items
    }
    
    // MARK: - Action
    // MARK: - Public
    @MainActor
    func sync(mediaItem: MediaItem?) async {
        guard let mediaItem else { return }
        withAnimation(.smooth) {
            for index in mediaItems.indices {
                mediaItems[index].isPlaying = (mediaItems[index].id == mediaItem.id)
            }
        }
    }
    
    @MainActor
    func play() async {
        await MediaPlayerService.shared.replaceQueue(items: mediaItems)
        await MediaPlayerService.shared.play()
        let playItemIndex = await MediaPlayerService.shared.indexOfNowPlayingItem()
        
        withAnimation(.smooth) {
            for index in mediaItems.indices {
                mediaItems[index].isPlaying = playItemIndex == index ? true : false
            }
        }
    }
    
    @MainActor
    func pause() async {
        await MediaPlayerService.shared.pause()
    }
    
    @MainActor
    func shufflePlay() async {
        await MediaPlayerService.shared.replaceQueue(items: mediaItems)
        await MediaPlayerService.shared.shufflePlay(with: .albums)
    }
    
    @MainActor
    func play(mediaItem: MediaItem) async {
        withAnimation(.smooth) {
            for index in mediaItems.indices {
                mediaItems[index].isPlaying = (mediaItems[index].id == mediaItem.id)
            }
        }
        
        await MediaPlayerService.shared.play(mediaItem, in: mediaItems)
    }
}

extension AlbumDetailData {
    static func mock() -> AlbumDetailData {
        let data = AlbumDetailData(
            album: MediaItemCollection(
                title: "Album",
                artist: "Artist",
                artwork: nil,
                items: [
                    MediaItem(
                        id: 1,
                        title: "밤바라빠 빠빠빠빠빠빠",
                        artist: "2NE1",
                        artwork: nil,
                        playbackDuration: 230,
                        isPlaying: true,
                        positionl: 1,
                        original: .init()
                    )
                ]
            )
        )
        return data
    }
}
