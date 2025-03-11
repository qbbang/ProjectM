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
        setupPlaybackObserver()
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
    
    private func setupPlaybackObserver() {
        $playbackStatus
            .sink { [weak self] status in
                if status == .playing {
                    self?.startTimer()
                } else {
                    self?.stopTimer()
                }
            }
            .store(in: &cancellables)
    }
    
    @discardableResult
    public func sync() async -> MediaItem? {
        let nowPlayingItem = await MediaPlayerService.shared.nowPlayingItem()
        let playbackState = await MediaPlayerService.shared.playbackState()
        let playTime = await MediaPlayerService.shared.playbackTime()
        let repeatMode = await MediaPlayerService.shared.repeatMode()
        
        self.nowPlayingItem = nowPlayingItem
        self.playbackStatus = playbackState == .playing ? .playing : .paused
        self.nowPlayTime = playTime
        self.repeatMode = repeatMode
        return nowPlayingItem
    }
    
    public func togglePlayback() async {
        if playbackStatus == .playing {
            await MediaPlayerService.shared.pause()
        } else {
            await MediaPlayerService.shared.play()
        }
        await sync()
    }
    
    public func skipToNextItem() async {
        await MediaPlayerService.shared.skipToNextItem()
        await sync()
    }
    
    public func skipToPreviousItem() async {
        await MediaPlayerService.shared.skipToPreviousItem()
        await sync()
    }
    
    public func seek(to time: TimeInterval) async {
        await MediaPlayerService.shared.seek(to: time)
        await sync()
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
        await sync()
    }
    
    public func shufflePlay() async {
        let items = self.album?.items ?? []
        await MediaPlayerService.shared.replaceQueue(items: items)
        await MediaPlayerService.shared.shufflePlay(with: .albums)
        await sync()
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
