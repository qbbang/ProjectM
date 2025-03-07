//
//  MediaPlayerService.swift
//  AudioService
//
//  Created by MK-AM16-009 on 3/7/25.
//

import MediaPlayer

public final actor MediaPlayerService: MediaPlayerServiceable {
    @MainActor
    private let musicPlayer = MPMusicPlayerApplicationController.systemMusicPlayer
    
    public init() { }
    
    public func requestAuthorization() async {
        await withCheckedContinuation { continuation in
            MPMediaLibrary.requestAuthorization { _ in
                continuation.resume()
            }
        }
    }
    
    public func fetchMediaQuery(for type: MPMediaQuery) async -> [MPMediaItem] {
        let query: MPMediaQuery
        
        switch type {
        case .songs():
            query = MPMediaQuery.songs()
        case .albums():
            query = MPMediaQuery.albums()
        case .artists():
            query = MPMediaQuery.artists()
        
        default:
            query = .init()
        }
        
        return query.items ?? []
    }
    
    public func replaceQueue(with mediaItems: [MPMediaItem]) async {
        let queue = MPMediaItemCollection(items: mediaItems)
        await musicPlayer.setQueue(with: queue)
    }
    
    public func playbackState() async -> MPMusicPlaybackState {
        await musicPlayer.playbackState
    }
    
    public func play() async {
        await musicPlayer.play()
    }
    
    public func pause() async {
        await musicPlayer.pause()
    }
    
    public func stop() async {
        await musicPlayer.stop()
    }
    
    public func restart() async {
        await musicPlayer.skipToBeginning()
        await musicPlayer.stop()
    }
}

extension MPMediaItem {
    /// 고유한 값이 없어 조합보다는 새로 생성해서 처리
    public var uuid: String {
        return UUID().uuidString
    }
}
