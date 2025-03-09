//
//  MediaPlayerServiceTests.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/7/25.
//

import Testing
@preconcurrency import MediaPlayer
@testable import MediaPlayerService

@Suite("MediaPlayerService")
/// 음악앱 접근은 시뮬레이션에서 불가함으로 디바이스에 음악 데이터를 밀어 넣고 진행해야 함.
struct MediaPlayerServiceTests {
    private let mediaPlayerService = MediaPlayerService.shared
    
    /// 실패 시 설정 -> 앱 ->  MusicPlayer에서 미디어 및 Apple Music를 수동으로 허용.
    @Test
    func requestAuthorization() async throws {
        let status = MPMediaLibrary.authorizationStatus()
        if status == .notDetermined {
            await mediaPlayerService.requestAuthorization()
        }
        
        #expect(MPMediaLibrary.authorizationStatus() == .authorized, "미디어 라이브러리 접근 권한이 필요합니다.")
    }
    
    @Test
    func fetchMediaQuery() async throws {
        let ablums = await mediaPlayerService.fetchMediaQuery(for: .albums())
        let songs = await mediaPlayerService.fetchMediaQuery(for: .songs())
        
        #expect(ablums.isEmpty == false, "앨범이 없습니다.")
        #expect(songs.isEmpty == false, "노래가 없습니다.")
    }
    
    @Test
    func mediaPlay() async throws {
        await setPlayList()
        await mediaPlayerService.play()
        try await Task.sleep(nanoseconds: 300_000_000)
        let state = await mediaPlayerService.playbackState()
        
        #expect(state == .playing, "음악이 재생되지 않습니다.")
    }
    
    @Test
    func mediaStop() async throws {
        let beforeState = await mediaPlayerService.playbackState()
        if beforeState != .playing {
            await setPlayList()
            await mediaPlayerService.play()
            try await Task.sleep(nanoseconds: 300_000_000)
        }
        
        await mediaPlayerService.stop()
        let currentState = await mediaPlayerService.playbackState()
        
        #expect(currentState == .paused, "음악이 정지되지 않습니다.")
    }
    
    @Test
    func mediaPause() async throws {
        let beforeState = await mediaPlayerService.playbackState()
        if beforeState != .playing {
            await setPlayList()
            await mediaPlayerService.play()
            try await Task.sleep(nanoseconds: 300_000_000)
        }
        
        await mediaPlayerService.pause()
        let currentState = await mediaPlayerService.playbackState()
        
        #expect(currentState == .paused, "음악이 일시정지되지 않습니다.")
    }
    
    @Test
    func mediaReset() async throws {
        let beforeState = await mediaPlayerService.playbackState()
        if beforeState != .playing {
            await setPlayList()
            await mediaPlayerService.play()
            try await Task.sleep(nanoseconds: 300_000_000)
        }
        
        await mediaPlayerService.restart()
        try await Task.sleep(nanoseconds: 300_000_000)
        let currentState = await mediaPlayerService.playbackState()
        
        #expect(currentState == .paused, "음악이 처음으로 돌아가지 않았습니다.")
    }
    
    @Test
    func playSelectedItem() async throws {
        let items = await mediaPlayerService.fetchMediaQuery(for: .songs()).map { MediaItem(from: $0) }
        guard let selectedItem = items.randomElement() else { return }
        
        await mediaPlayerService.play(selectedItem, in: items)
        
        guard let item = await mediaPlayerService.nowPlayingItem() else {
            return
        }
        
        print(items.map { $0.title })
        print(selectedItem.title)
        print(item.title)
        #expect(selectedItem.title == item.title, "선택된 음악이 다릅니다")
    }
    
    private func setPlayList() async {
        let items = await mediaPlayerService.fetchMediaQuery(for: .songs())
        let modifierItems = items.map { MediaItem(from: $0)}
        await mediaPlayerService.replaceQueue(items: modifierItems)
    }
}
