//
//  ShuffleMode.swift
//  MediaPlayerService
//
//  Created by MK-AM16-009 on 3/11/25.
//

import Foundation
import MediaPlayer

public enum ShuffleMode {
    case off
    case songs
    case albums
    case `default`
}

extension ShuffleMode {
    init(mpMusicShuffleMode: MPMusicShuffleMode) {
        switch mpMusicShuffleMode {
        case .off:
            self = .off
        case .songs:
            self = .songs
        case .albums:
            self = .albums
        case .default:
            self = .default
        /// Switch covers known cases, but 'MPMusicRepeatMode' may have additional unknown values, possibly added in future versions; this is an error in the Swift 6 language mode
        @unknown default:
            self = .off
        }
    }
    
    func toMPMusicShuffleMode() -> MPMusicShuffleMode {
        switch self {
        case .off:
            return .off
        case .songs:
            return .songs
        case .albums:
            return .albums
        case .default:
            return .default
        }
    }
}
