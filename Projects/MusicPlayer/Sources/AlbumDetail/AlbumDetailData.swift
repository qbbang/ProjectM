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
    func play() async {
        await MediaPlayerService.shared.replaceQueue(items: mediaItems)
        await MediaPlayerService.shared.play()
    }
    
    @MainActor
    func pause() async {
        await MediaPlayerService.shared.pause()
    }
    
    @MainActor
    func shuffle() async {
        var shuffleMediaItems = mediaItems
        shuffleMediaItems.shuffle()
        mediaItems = shuffleMediaItems
        await MediaPlayerService.shared.shuffle(items: shuffleMediaItems)
    }
    
    @MainActor
    func play(mediaItem: MediaItem) async {
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
                        id: 123,
                        title: "내가 제일 잘 나가",
                        original: .init()
                    ),
                    MediaItem(
                        id: 234,
                        title: "밤바라빠 빠빠빠빠빠빠 ",
                        original: .init()
                    ),
                    MediaItem(
                        id: 345,
                        title: "누가 봐도 내가 좀 죽여주잖아",
                        original: .init()
                    ),
                    MediaItem(
                        id: 456,
                        title: "타이틀",
                        original: .init()
                    ),
                    MediaItem(
                        id: 567,
                        title: "무제",
                        original: .init()
                    )
                ]
            )
        )
        return data
    }
}
