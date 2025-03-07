//
//  MediaPlayerService.swift
//  AudioService
//
//  Created by MK-AM16-009 on 3/7/25.
//

import MediaPlayer

final class MediaPlayerService: MediaPlayerServiceable {
    private let musicPlayer = MPMusicPlayerApplicationController.systemMusicPlayer
    
    func fetchMediaQuery(for type: MPMediaQuery) -> MPMediaQuery {
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
    
    func replaceQueue(with mediaItems: [MPMediaItem]) {
        let queue = MPMediaItemCollection(items: mediaItems)
        musicPlayer.setQueue(with: queue)
    }
    
    func play() {
        musicPlayer.play()
    }
    
    func pause() {
        musicPlayer.pause()
    }
    
    func stop() {
        musicPlayer.stop()
    }    
}
