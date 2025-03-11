//
//  MiniPlayerData.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/9/25.
//

import SwiftUI
import MediaPlayerService

@MainActor
public final class MiniPlayerData: ObservableObject {
    @Published public private(set) var isMediaItemsFetched = false
    @Published public private(set) var miniPlayerHeight: CGFloat = 80
    @Published public private(set) var playbackStatus: PlaybackStatus = .paused
    @Published public private(set) var nowPlayingItem: MediaItem? = nil
    @Published public private(set) var nowPlayTime: TimeInterval = 0
    @Published public private(set) var nowPlayDuration: TimeInterval = 0
    @Published public private(set) var repeatMode: RepeatMode = .none
    
    private var timer: Timer?
    private var album: MediaItemCollection?
    
    var title: String { nowPlayingItem?.title ?? "재생 중인 곡이 없습니다." }
    var artistName: String { nowPlayingItem?.artist ?? "Unknown Artist" }
    var artwork: Image? { nowPlayingItem?.artwork }
    
    public init() { }
    
    // MARK: - Functions
    // MARK: Public(authorization)
    public func fetchedAlbumList() async {
        isMediaItemsFetched = true
    }
    
    // MARK: Public(miniPlayer Actions)
    @MainActor
    public func requestAuthorization() async ->  MediaPlayerAuthorizationStatus {
        await MediaPlayerService.shared.requestAuthorization()
    }
    
    /// paused인 경우 nowPlayingItem가 nil 아님.
    @MainActor
    @discardableResult
    public func sync() async -> MediaItem? {
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
        
        return nowPlayingItem
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
            nextRepeatMode = .all
        case .one:
            nextRepeatMode = .none
        case .all:
            nextRepeatMode = .one
        case .default:
            nextRepeatMode = .none
        }
        await MediaPlayerService.shared.repeatMode(nextRepeatMode)
        self.repeatMode = nextRepeatMode
    }
    
    @MainActor
    public func shufflePlay() async {
        let items = self.album?.items ?? []
        print("✅ items: ",items)
        await MediaPlayerService.shared.replaceQueue(items: items)
        await MediaPlayerService.shared.shufflePlay(with: .albums)
        
        // TODO: 업데이트해서 디테일에 반영해야함. 노티랑 해당 클래스로 모두 이관하면 처리될 문제
    }
    
    public func updateAlbum(_ album: MediaItemCollection) async {
        self.album = album
    }
    
    public func isPlayingAlbum(_ album: MediaItemCollection) -> Bool {
        guard let nowPlaying = nowPlayingItem else { return false }
        return playbackStatus == .playing &&
        nowPlaying.original.albumPersistentID == album.original.representativeItem?.albumPersistentID
    }
    
    
    // MARK: Private
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
                
                if await self.nowPlayDuration <= 1 {
                    await self.endGeneratingPlayback()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // TODO: beginGeneratingPlaybackNotifications 대체
    private func endGeneratingPlayback() async {
        stopTimer()
        await MediaPlayerService.shared.stop()
        await MediaPlayerService.shared.skipToNextItem()
        await MediaPlayerService.shared.play()
        await sync()
    }
}
