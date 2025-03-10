//
//  RepeatMode.swift
//  MediaPlayerService
//
//  Created by MK-AM16-009 on 3/10/25.
//

import SwiftUI
import MediaPlayer

public enum RepeatMode {
    case `default`
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
            // TODO: 커스텀심볼로 짝대기 해서 이미지 교체할 것
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
