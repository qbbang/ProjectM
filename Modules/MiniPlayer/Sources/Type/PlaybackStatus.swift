//
//  PlaybackStatus.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/10/25.
//

import Foundation

public enum PlaybackStatus {
    case playing
    case paused

    var buttonImage: String {
        switch self {
        case .playing: return "pause.fill"
        case .paused:  return "play.fill"
        }
    }
}
