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
    @Published public private(set) var playbackState = (isPlaying: false, buttonImage: "play.fill")
    @Published public private(set) var nowPlayingItem: MediaItem? = nil
    
    public init() {
    }
    
    var title: String {
        nowPlayingItem?.title ?? "재생 중인 곡이 없습니다."
    }
    
    var artistName: String {
        nowPlayingItem?.artist ?? "Unknown Artist"
    }
    
    var artwork: Image? {
        nowPlayingItem?.artwork
    }
    
    /// paused인 경우 nowPlayingItem가 nil 아님.
    @MainActor
    public func sync() async {
        let nowPlayingItem = await Task {
            await MediaPlayerService.shared.nowPlayingItem()
        }.value
        
        let playbackState = await Task {
            await MediaPlayerService.shared.playbackState()
        }.value
        
        self.playbackState = playbackState == .playing ?
        (true, "pause.fill") : (false, "play.fill")
        self.nowPlayingItem = nowPlayingItem
    }
    
    @MainActor
    public func updatePlaybackState() async {
        if playbackState.isPlaying {
            Task {
                await MediaPlayerService.shared.pause()
                playbackState = (false, "play.fill")
            }
        } else {
            Task {
                await MediaPlayerService.shared.play()
                playbackState = (true, "pause.fill")
            }
        }
    }
    
    @MainActor
    public func updatePlaybackState(nowPlayingItem: MediaItem?) async {
        self.nowPlayingItem = nowPlayingItem
    }
}
