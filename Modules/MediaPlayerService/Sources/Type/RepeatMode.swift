//
//  RepeatMode.swift
//  MediaPlayerService
//
//  Created by MK-AM16-009 on 3/10/25.
//

import SwiftUI
import MediaPlayer

/// 정책) 기본적으로 none을 제공하며 시스템과 동일하게 반복안함, 1곡, 전체 반복만 지원한다.
public enum RepeatMode {
    case `default`  /// 사용하지 않는 모드
    case one
    case all
    case none
    
    public var image: String {
        switch self {
        case .all:
            return "infinity"
        case .default:
            return "repeat"
        case .one:
            return "repeat.1"
        case .none:
            return "repeat"
        }
    }
}

extension RepeatMode {
    init(mpMusicRepeatMode: MPMusicRepeatMode) {
        switch mpMusicRepeatMode {
        case .default:
            self = .default
        case .one:
            self = .one
        case .all:
            self = .all
        case .none:
            self = .none
            /// Switch covers known cases, but 'MPMusicRepeatMode' may have additional unknown values, possibly added in future versions; this is an error in the Swift 6 language mode
        @unknown default:
            self = .none
        }
    }
    
    func toMPMusicRepeatMode() -> MPMusicRepeatMode {
        switch self {
        case .default:
            return .default
        case .one:
            return .one
        case .all:
            return .all
        case .none:
            return .none
        }
    }
}
