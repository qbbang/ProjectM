import SwiftUI
import MediaPlayerService
import Combine

@MainActor
public final class MiniPlayerData: ObservableObject {
    @Published public private(set) var isMediaItemsFetched = false
    @Published public private(set) var miniPlayerHeight: CGFloat = 80
    @Published public private(set) var playbackStatus: PlaybackStatus = .paused
    @Published public private(set) var nowPlayingItem: MediaItem? = nil
    @Published public private(set) var nowPlayTime: TimeInterval = 0
    @Published public private(set) var nowPlayDuration: TimeInterval = 0
    @Published public private(set) var repeatMode: RepeatMode = .none
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var album: MediaItemCollection?
    
    var title: String { nowPlayingItem?.title ?? "재생 중인 곡이 없습니다." }
    var artistName: String { nowPlayingItem?.artist ?? "Unknown Artist" }
    var artwork: Image? { nowPlayingItem?.artwork }
    
    public init() {
        Task { await notificationObservers() }
    }
    
    /*
     PlaybackState 노티 이후 playbackState() async -> MPMusicPlaybackState 으로 재생/정지 상태를 췍
     NowPlayingItemDidChange 노티 이후 nowPlayingItem() async -> MediaItem? 으로 현재 곡 췍
     
     MPMusicPlayerControllerPlaybackStateDidChange
     MPMusicPlayerControllerNowPlayingItemDidChange
     MPMediaLibraryDidChange
     MPMusicPlayerControllerQueueDidChange
     */
    private func notificationObservers() async {
        await MediaPlayerService.shared.beginGeneratingPlaybackNotifications()
        
        /// 음악 재생 후 진입 시
        /// VolumeDidChange -> VolumeDidChange
        ///
        /// 음악 재생 중 -> 음악 정지
        /// PlaybackStateDidChange -> PlaybackStateDidChange -> PlaybackStateDidChange
        ///
        /// 음악 재생 중 -> 셔플
        /// PlaybackStateDidChange -> NowPlayingItemDidChange -> QueueDidChange -> NowPlayingItemDidChange -> PlaybackStateDidChange
        NotificationCenter.default
            .publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] info in
                Task {
                    let playbackState = await MediaPlayerService.shared.playbackState()
                    self?.playbackStatus = playbackState == .playing ? .playing : .paused
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
                    
                    self?.nowPlayingItem = nowPlayingItem
                    self?.nowPlayTime = playbackTime
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .MPMusicPlayerControllerQueueDidChange)
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] info in
                Task {
                    let repeatMode = await MediaPlayerService.shared.repeatMode()
                    self?.repeatMode = repeatMode
                }
            }
            .store(in: &cancellables)
    }
    
    
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
        let items = self.album?.items ?? []
        await MediaPlayerService.shared.replaceQueue(items: items)
        await MediaPlayerService.shared.shufflePlay(with: .albums)
    }
    
    public func requestAuthorization() async -> MediaPlayerAuthorizationStatus {
        await MediaPlayerService.shared.requestAuthorization()
    }
    
    public func fetchedAlbumList() async {
        isMediaItemsFetched = true
    }
    
    public func updateAlbum(_ album: MediaItemCollection) async {
        self.album = album
    }
    
    public func isPlayingAlbum(_ album: MediaItemCollection) -> Bool {
        guard let nowPlaying = nowPlayingItem else { return false }
        return playbackStatus == .playing &&
        nowPlaying.original.albumPersistentID == album.original.representativeItem?.albumPersistentID
    }
}
