//
//  MediaPlayerServiceable.swift
//  AudioService
//
//  Created by MK-AM16-009 on 3/7/25.
//

import MediaPlayer

public protocol MediaPlayerServiceable {
    func requestAuthorization() async
    func fetchAlbumDisplayItems() async -> [MediaItemCollection]
    func fetchMediaQuery(for type: MPMediaQuery) async -> [MPMediaItem]
    func replaceQueue(items: [MediaItem]) async
    func replaceQueue(collection: MPMediaItemCollection) async
    
    /// stopped, playing, paused, interrupted, seekingForward, seekingBackward 상태를 가짐.
    /// https://developer.apple.com/documentation/mediaplayer/mpmusicplaybackstate
    func playbackState() async -> MPMusicPlaybackState
    func play() async
    func pause() async      /// paused 상태를 가짐
    func stop() async       /// paused 상태를 가짐
    func restart() async    /// paused 상태를 가짐
    func shuffle(items: [MediaItem]) async
    func play(_ selectedItem: MediaItem, in items: [MediaItem]) async
    func nowPlayingItem() async -> MediaItem?
}
