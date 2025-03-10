//
//  MediaPlayerService.swift
//  AudioService
//
//  Created by MK-AM16-009 on 3/7/25.
//

import MediaPlayer

/**
SwiftUI에서 의존성 주입(DI)은 보통 EnvironmentObject를 통해 이루어지는데, ObservableObject를 채택해야함.
하지만 MediaPlayerService는 동시성 보장을 위해 actor로 선언되어 있고, ObservableObject를 채택할 수 없음
인스턴스 넘기는 구조에서 개선을 고민하다가 해당 이슈에 따라 싱글톤 패턴(MediaPlayerService.shared)으로 변경함.
향후 명시적 의존성을 위해 모듈 구조를 재검토할 수 있음.
  ex) 모듈을 사용하는 프로젝트에서 클래스로 감싸서 사용하거나 등등
 */
public final actor MediaPlayerService: MediaPlayerServiceable {
    
    public static let shared = MediaPlayerService()
    
    private init() { }
    
    @MainActor
    private let musicPlayer = MPMusicPlayerApplicationController.systemMusicPlayer
    
    public func requestAuthorization() async -> MediaPlayerAuthorizationStatus {
        await withCheckedContinuation { continuation in
            MPMediaLibrary.requestAuthorization { status in
                let authorizationStatus: MediaPlayerAuthorizationStatus
                switch status {
                case .notDetermined:
                    authorizationStatus = .notDetermined
                case .denied:
                    authorizationStatus = .denied
                case .restricted:
                    authorizationStatus = .restricted
                case .authorized:
                    authorizationStatus = .authorized
                /// Switch covers known cases, but 'MPMediaLibraryAuthorizationStatus' may have additional unknown values, possibly added in future versions; this is an error in the Swift 6 language mode
                @unknown default:
                    authorizationStatus = .notDetermined
                }
                
                continuation.resume(returning: authorizationStatus)
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
    
    public func playbackTime() async -> TimeInterval {
        await musicPlayer.currentPlaybackTime
    }
    
    public func seek(to time: TimeInterval) async {
        await musicPlayer.currentPlaybackTime = time
    }
    
    public func indexOfNowPlayingItem() async -> Int {
        await musicPlayer.indexOfNowPlayingItem
    }
    
    public func skipToNextItem() async {
        await musicPlayer.skipToNextItem()
    }
    
    public func skipToPreviousItem() async {
        await musicPlayer.skipToPreviousItem()
    }
    
    public func repeatMode() async -> RepeatMode {
        await RepeatMode(mpMusicRepeatMode: musicPlayer.repeatMode)
    }
    
    public func repeatMode(_ mode: RepeatMode) async {
        await musicPlayer.repeatMode = mode.toMPMusicRepeatMode()
    }
    
    public func beginGeneratingPlaybackNotifications() async {
        await musicPlayer.beginGeneratingPlaybackNotifications()
    }
    
    public func endGeneratingPlaybackNotifications() async {
        await musicPlayer.endGeneratingPlaybackNotifications()
    }
}
