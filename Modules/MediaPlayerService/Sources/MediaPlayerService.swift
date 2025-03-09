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
    
    public func fetchAlbumDisplayItems() async -> [MediaItemCollection] {
        let albums = MPMediaQuery.albums().collections ?? []
        return albums.map { MediaItemCollection(from: $0) }
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
    
    public func replaceQueue(items: [MediaItem]) async {
        let originalItems = items.map { $0.originalObject }
        let queue = MPMediaItemCollection(items: originalItems)
        await musicPlayer.setQueue(with: queue)
    }
    
    public func replaceQueue(collection: MPMediaItemCollection) async {
        await musicPlayer.setQueue(with: collection)
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
    
    public func shuffle(items: [MediaItem]) async {
        await musicPlayer.stop()
        let originalItems = items.map { $0.originalObject }
        let shuffleQueue = MPMediaItemCollection(items: originalItems)
        await musicPlayer.setQueue(with: shuffleQueue)
        await musicPlayer.play()
    }
    
    public func play(_ selectedItem: MediaItem, in items: [MediaItem]) async {
        await musicPlayer.stop()
        let originalItems = items.map { $0.originalObject }
        let itemCollection = MPMediaItemCollection(items: originalItems)
        let queueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: itemCollection)
        queueDescriptor.startItem = selectedItem.originalObject
        await musicPlayer.setQueue(with: queueDescriptor)
        await musicPlayer.play()
    }
    
    public func nowPlayingItem() async -> MediaItem? {
        guard let nowPlayingItem = await musicPlayer.nowPlayingItem else {
            return nil
        }
        
        return MediaItem(from: nowPlayingItem)
    }
}
