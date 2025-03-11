import SwiftUI
import MediaPlayerService
import Combine

@MainActor
public final class MiniPlayerData: ObservableObject {
    // MARK: - Properties
    // MARK: Public
    @Published public private(set) var isMediaItemsFetched = false
    @Published public private(set) var miniPlayerHeight: CGFloat = 80
    @Published public private(set) var playbackStatus: PlaybackStatus = .paused
    @Published public private(set) var nowPlayingItem: MediaItem? = nil
    @Published public private(set) var nowPlayTime: TimeInterval = 0
    @Published public private(set) var repeatMode: RepeatMode = .none
    
    var title: String { nowPlayingItem?.title ?? "재생 중인 곡이 없습니다." }
    var artistName: String { nowPlayingItem?.artist ?? "Unknown Artist" }
    var artwork: Image? { nowPlayingItem?.artwork }
    
    // MARK: Private
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var albumList = [MediaItemCollection]()
    
    // MARK: - Initializer
    public init() {
        Task { await notificationObservers() }
    }
    // MARK: - Funtions
    // MARK: Public
    public func fetched(_ albumList: [MediaItemCollection]) async {
        self.albumList = albumList
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.updateNowPlayingItem() }
            group.addTask { await self.updatePlaybackState() }
            group.addTask { await self.updateQueueDidChange() }
        }
        
        isMediaItemsFetched = true
    }
    
    public func togglePlayback() async {
        if playbackStatus == .playing {
            await MediaPlayerService.shared.pause()
        } else {
            await MediaPlayerService.shared.play()
        }
    }
    
    public func skipToNextItem() async {
        await MediaPlayerService.shared.skipToNextItem()
    }
    
    public func skipToPreviousItem() async {
        await MediaPlayerService.shared.skipToPreviousItem()
    }
    
    public func seek(to time: TimeInterval) async {
        await MediaPlayerService.shared.seek(to: time)
        self.nowPlayTime = time
    }
    
    public func repeatMode() async {
        let nextRepeatMode: RepeatMode
        switch repeatMode {
        case .none: nextRepeatMode = .all
        case .one: nextRepeatMode = .none
        case .all: nextRepeatMode = .one
        case .default: nextRepeatMode = .none
        }
        await MediaPlayerService.shared.repeatMode(nextRepeatMode)
        self.repeatMode = nextRepeatMode
    }
    
    public func shufflePlay() async {
        let playingAlbum = self.albumList.first {
            $0.original.representativeItem?.albumPersistentID == self.nowPlayingItem?.original.albumPersistentID
        }
        let items = playingAlbum?.items ?? []
        await MediaPlayerService.shared.replaceQueue(items: items)
        await MediaPlayerService.shared.shufflePlay(with: .albums)
    }
    
    public func requestAuthorization() async -> MediaPlayerAuthorizationStatus {
        await MediaPlayerService.shared.requestAuthorization()
    }
    
    public func isPlayingAlbum(_ album: MediaItemCollection) -> Bool {
        guard let nowPlaying = nowPlayingItem else { return false }
        return playbackStatus == .playing &&
        nowPlaying.original.albumPersistentID == album.original.representativeItem?.albumPersistentID
    }
    
    // MARK: Private(Data)
    private func updateNowPlayingItem() async {
        self.nowPlayingItem = await MediaPlayerService.shared.nowPlayingItem()
        self.nowPlayTime = await MediaPlayerService.shared.playbackTime()
    }
    
    private func updatePlaybackState() async {
        let playbackStatus = await MediaPlayerService.shared.playbackState()
        self.playbackStatus = playbackStatus == .playing ? .playing : .paused
    }
    
    private func updateQueueDidChange() async {
        self.nowPlayingItem = await MediaPlayerService.shared.nowPlayingItem()
    }
    
    // MARK: Private(Notification)
    private func notificationObservers() async {
        await MediaPlayerService.shared.beginGeneratingPlaybackNotifications()
        
        NotificationCenter.default
            .publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] info in
                Task {
                    let playbackState = await MediaPlayerService.shared.playbackState()
                    self?.playbackStatus = playbackState == .playing ? .playing : .paused
                    
                    await MainActor.run {
                        if self?.playbackStatus == .playing {
                            self?.startTimer()
                        } else {
                            self?.stopTimer()
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .MPMusicPlayerControllerNowPlayingItemDidChange)
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] info in
                Task {
                    let nowPlayingItem = await MediaPlayerService.shared.nowPlayingItem()
                    let playbackTime = await MediaPlayerService.shared.playbackTime()
                    
                    await MainActor.run {
                        self?.nowPlayingItem = nowPlayingItem
                        self?.nowPlayTime = playbackTime
                    }
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .MPMusicPlayerControllerQueueDidChange)
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] info in
                Task {
                    let repeatMode = await MediaPlayerService.shared.repeatMode()
                    
                    await MainActor.run {
                        self?.repeatMode = repeatMode
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: Private(Timer)
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { [weak self] in
                guard let self = self else { return }
                let playTime = await MediaPlayerService.shared.playbackTime()
                await MainActor.run {
                    self.nowPlayTime = playTime
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
   
}
