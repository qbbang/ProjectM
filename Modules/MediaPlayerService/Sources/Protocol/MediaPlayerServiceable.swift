//
//  MediaPlayerServiceable.swift
//  AudioService
//
//  Created by MK-AM16-009 on 3/7/25.
//

import MediaPlayer

/// https://developer.apple.com/documentation/mediaplayer
public protocol MediaPlayerServiceable {
    func requestAuthorization() async -> MediaPlayerAuthorizationStatus
    func beginGeneratingPlaybackNotifications() async
    func endGeneratingPlaybackNotifications() async
    
    func fetchAlbumDisplayItems() async -> [MediaItemCollection]
    func fetchMediaQuery(for type: MPMediaQuery) async -> [MPMediaItem]
    func replaceQueue(items: [MediaItem]) async
    func playbackState() async -> MPMusicPlaybackState
    func play() async
    func pause() async
    func stop() async
    func restart() async
    func shuffleMode() async -> ShuffleMode
    func shufflePlay(with mode: ShuffleMode) async
    func play(_ selectedItem: MediaItem, in items: [MediaItem]) async
    func nowPlayingItem() async -> MediaItem?
    func playbackTime() async -> TimeInterval
    func seek(to time: TimeInterval) async
    func indexOfNowPlayingItem() async -> Int
    func skipToNextItem() async
    func skipToPreviousItem() async
    func repeatMode() async -> RepeatMode
    func repeatMode(_ mode: RepeatMode) async
}
