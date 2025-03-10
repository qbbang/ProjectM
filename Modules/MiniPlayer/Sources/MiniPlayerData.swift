//
//  MiniPlayerData.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/9/25.
//

import SwiftUI
import MediaPlayerService

public final class MiniPlayerData: ObservableObject {
    @Published public private(set) var miniPlayerHeight: CGFloat = 80
    @Published public private(set) var playbackStatus: PlaybackStatus = .paused
    @Published public private(set) var nowPlayingItem: MediaItem? = nil
    
    public init() { }
    
    var title: String { nowPlayingItem?.title ?? "재생 중인 곡이 없습니다." }
    var artistName: String { nowPlayingItem?.artist ?? "Unknown Artist" }
    var artwork: Image? { nowPlayingItem?.artwork }
    
    /// paused인 경우 nowPlayingItem가 nil 아님.
    @MainActor
    public func sync() async {
        let nowPlayingItem = await MediaPlayerService.shared.nowPlayingItem()
        let playbackState = await MediaPlayerService.shared.playbackState()
        
        self.nowPlayingItem = nowPlayingItem
        self.playbackStatus = playbackState == .playing ? .playing : .paused
    }
    
    @MainActor
    public func togglePlayback() async {
        if playbackStatus == .playing {
            await MediaPlayerService.shared.pause()
            playbackStatus = .paused
        } else {
            await MediaPlayerService.shared.play()
            playbackStatus = .playing
        }
    }
    
    public func isPlayingAlbum(_ album: MediaItemCollection) -> Bool {
        guard let nowPlaying = nowPlayingItem else { return false }
        return playbackStatus == .playing &&
        nowPlaying.original.albumPersistentID == album.original.representativeItem?.albumPersistentID
    }
    
}
