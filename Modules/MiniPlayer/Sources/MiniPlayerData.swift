//
//  MiniPlayerData.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/9/25.
//

import SwiftUI
import Combine
import MediaPlayerService

public final class MiniPlayerData: ObservableObject {
    @Published public private(set) var miniPlayerHeight: CGFloat = 80
    @Published public private(set) var playbackStatus: PlaybackStatus = .paused
    @Published public private(set) var nowPlayingItem: MediaItem? = nil
    @Published public private(set) var nowPlayTime: TimeInterval = 0
    @Published public private(set) var nowPlayDuration: TimeInterval = 0
    @Published public private(set) var repeatMode: RepeatMode = .default
    
    private var timer: Timer?
    private var isEditingDuration = false
    private var cancellables: Set<AnyCancellable> = []
    
    var title: String { nowPlayingItem?.title ?? "재생 중인 곡이 없습니다." }
    var artistName: String { nowPlayingItem?.artist ?? "Unknown Artist" }
    var artwork: Image? { nowPlayingItem?.artwork }
    
    public init() { }
    
    /// paused인 경우 nowPlayingItem가 nil 아님.
    @MainActor
    public func sync() async {
        let nowPlayingItem = await MediaPlayerService.shared.nowPlayingItem()
        let playbackState = await MediaPlayerService.shared.playbackState()
        let playTime = await MediaPlayerService.shared.playbackTime()
        let repeatMode = await MediaPlayerService.shared.repeatMode()
        
        self.nowPlayingItem = nowPlayingItem
        self.playbackStatus = playbackState == .playing ? .playing : .paused
        self.nowPlayTime = playTime
        self.repeatMode = repeatMode
        
        if playbackState == .playing {
            startTimer()
        } else {
            stopTimer()
        }
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
    
    @MainActor
    public func skipToNextItem() async {
        await MediaPlayerService.shared.skipToNextItem()
    }
    
    @MainActor
    public func skipToPreviousItem() async {
        await MediaPlayerService.shared.skipToPreviousItem()
    }
    
    @MainActor
    public func seek(to time: TimeInterval) async {
        await MediaPlayerService.shared.seek(to: time)
    }
    
    @MainActor
    public func repeatMode() async {
        let nextRepeatMode: RepeatMode
        
        switch repeatMode {
        case .none:
            nextRepeatMode = .one
        case .one:
            nextRepeatMode = .all
        case .all:
            nextRepeatMode = .default
        case .default:
            nextRepeatMode = .none
        }
        await MediaPlayerService.shared.repeatMode(nextRepeatMode)
        self.repeatMode = nextRepeatMode
    }
    
    public func isPlayingAlbum(_ album: MediaItemCollection) -> Bool {
        guard let nowPlaying = nowPlayingItem else { return false }
        return playbackStatus == .playing &&
        nowPlaying.original.albumPersistentID == album.original.representativeItem?.albumPersistentID
    }
    
    private func startTimer() {
        let nowPlayDuration = nowPlayingItem?.playbackDuration ?? 0
        
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task {
                let time = await MediaPlayerService.shared.playbackTime()
                await MainActor.run {
                    self.nowPlayTime = time
                    self.nowPlayDuration = nowPlayDuration - time
                }
                
                // TODO: beginGeneratingPlaybackNotifications 대체할 방안 구상하기
                if self.nowPlayDuration <= 1 {
                    
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
