//
//  MediaPlayerServiceable.swift
//  AudioService
//
//  Created by MK-AM16-009 on 3/7/25.
//

import MediaPlayer

public protocol MediaPlayerServiceable {
    func requestAuthorization() async -> MediaPlayerAuthorizationStatus
    func fetchAlbumDisplayItems() async -> [MediaItemCollection]
    func fetchMediaQuery(for type: MPMediaQuery) async -> [MPMediaItem]
    func replaceQueue(items: [MediaItem]) async
    func replaceQueue(collection: MPMediaItemCollection) async
    
    /// stopped, playing, paused, interrupted, seekingForward, seekingBackward 상태를 가짐.
    /// https://developer.apple.com/documentation/mediaplayer/mpmusicplaybackstate
    func playbackState() async -> MPMusicPlaybackState
    func play() async
    
    /// paused 상태를 가짐
    func pause() async
    
    /// paused 상태를 가짐
    func stop() async
    
    /// paused 상태를 가짐
    func restart() async
    
    /// 모델에서 배열을 관리하기 위해 프레임워크에서 제공하는 임의 재생 기능(shuffleMode)을 사용하지 않고
    /// replaceQueue 조합하여 사용함.
    func shuffle(items: [MediaItem]) async
    func play(_ selectedItem: MediaItem, in items: [MediaItem]) async
    func nowPlayingItem() async -> MediaItem?
    func playbackTime() async -> TimeInterval
    func seek(to time: TimeInterval) async
    func indexOfNowPlayingItem() async -> Int
    func skipToNextItem() async
    func skipToPreviousItem() async
}
