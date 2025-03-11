//
//  MiniPlayerData+AsyncStream.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/11/25.
//

import Foundation
import MediaPlayerService

/// https://developer.apple.com/documentation/swift/asyncstream
/// MiniPlayer 모듈의 @Published 값이 변경되면 이벤트가 발생함.
extension MiniPlayerData {
    public var nowPlayingItemStream: AsyncStream<MediaItem?> {
        AsyncStream { continuation in
            let cancellable = $nowPlayingItem.sink { value in
                continuation.yield(value)
            }
            continuation.onTermination = { _ in cancellable.cancel() }
        }
    }
    
    public var playbackStatusStream: AsyncStream<PlaybackStatus> {
        AsyncStream { continuation in
            let cancellable = $playbackStatus.sink { value in
                continuation.yield(value)
            }
            continuation.onTermination = { _ in cancellable.cancel() }
        }
    }
}

