//
//  MediaPlayerServiceable.swift
//  AudioService
//
//  Created by MK-AM16-009 on 3/7/25.
//

import MediaPlayer

public protocol MediaPlayerServiceable {
    func requestAuthorization() async
    func fetchAlbumDisplayItems() async -> [AlbumDisplayItem]
    func fetchMediaQuery(for type: MPMediaQuery) async -> [MPMediaItem]
    func replaceQueue(items: [MPMediaItem]) async
    func replaceQueue(collection: MPMediaItemCollection) async
    func playbackState() async -> MPMusicPlaybackState
    func play() async
    func pause() async      /// paused 상태를 가짐
    func stop() async       /// paused 상태를 가짐
    func restart() async    /// paused 상태를 가짐
    func shuffle(items: [MPMediaItem]) async
}
