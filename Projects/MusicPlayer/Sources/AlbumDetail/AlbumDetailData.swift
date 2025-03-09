//
//  AlbumDetailData.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/8/25.
//

import SwiftUI
import MediaPlayerService

final class AlbumDetailData: ObservableObject {
    private let album: MediaItemCollection
    
    @Published var mediaItems: [MediaItem] = []
    @Published var playbackState = (isPlaying: false, buttonImage: "play.fill")
    
    var title: String {
        album.title
    }
    
    var artwork: Image? {
        album.artwork
    }
    
    var artistName: String {
        album.artist
    }
    
    init(album: MediaItemCollection) {
        self.album = album
        
        mediaItems = album.items
    }
    
    
    // MARK: - Action
    // MARK: - Public
    @MainActor
    func play() async {
        updatePlayButton(for: true)
        Task {
            await MediaPlayerService.shared.replaceQueue(items: mediaItems)
            await MediaPlayerService.shared.play()
        }
    }
    
    @MainActor
    func pause() async {
        updatePlayButton(for: false)
        Task { await MediaPlayerService.shared.pause() }
    }
    
    @MainActor
    func shuffle() async {
        var shuffleMediaItems = mediaItems
        shuffleMediaItems.shuffle()
        mediaItems = shuffleMediaItems
        updatePlayButton(for: true)
        
        Task { await MediaPlayerService.shared.shuffle(items: shuffleMediaItems) }
    }
    
    @MainActor
    func play(mediaItem: MediaItem) async {
        updatePlayButton(for: true)
        Task { await MediaPlayerService.shared.play(mediaItem, in: mediaItems) }
    }
    
    @MainActor
    func updatePlaybackState() async {
        let state = await Task {
            await MediaPlayerService.shared.playbackState()
        }.value
        
        guard state == .playing else {
            updatePlayButton(for: false)
            return
        }
        
        let nowPlayingAlbumPersistentID = await Task {
            await MediaPlayerService.shared.nowPlayingItem()?.original.albumPersistentID
        }.value
        
        if nowPlayingAlbumPersistentID == album.original.representativeItem?.albumPersistentID {
            updatePlayButton(for: true)
        }
    }
    
    // MARK: Private
    private func updatePlayButton(for isPlaying: Bool) {
        let buttonImage = isPlaying ? "pause.fill" : "play.fill"
        playbackState = (isPlaying: isPlaying, buttonImage: buttonImage)
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
