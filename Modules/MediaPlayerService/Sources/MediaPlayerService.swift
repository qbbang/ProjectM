//
//  MediaPlayerService.swift
//  AudioService
//
//  Created by MK-AM16-009 on 3/7/25.
//

import MediaPlayer

final actor MediaPlayerService: MediaPlayerServiceable {
    @MainActor
    private let musicPlayer = MPMusicPlayerApplicationController.systemMusicPlayer
    
    func requestAuthorization() async {
        await withCheckedContinuation { continuation in
            MPMediaLibrary.requestAuthorization { _ in
                continuation.resume()
            }
        }
    }
    
    func fetchMediaQuery(for type: MPMediaQuery) async -> MPMediaQuery {
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
        
        return query
    }
    
    func replaceQueue(with mediaItems: [MPMediaItem]) async {
        let queue = MPMediaItemCollection(items: mediaItems)
        await musicPlayer.setQueue(with: queue)
    }
    
    func playbackState() async -> MPMusicPlaybackState {
        await musicPlayer.playbackState
    }
    
    func play() async {
        await musicPlayer.play()
    }
    
    func pause() async {
        await musicPlayer.pause()
    }
    
    func stop() async {
        await musicPlayer.stop()
    }
    
    func restart() async {
        await musicPlayer.skipToBeginning()
        await musicPlayer.stop()
    }
}
