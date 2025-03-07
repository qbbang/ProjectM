//
//  MediaPlayerServiceable.swift
//  AudioService
//
//  Created by MK-AM16-009 on 3/7/25.
//

import MediaPlayer

public protocol MediaPlayerServiceable {
    func fetchMediaQuery(for type: MPMediaQuery) -> MPMediaQuery
    func replaceQueue(with mediaItems: [MPMediaItem])
    func play()
    func pause()
    func stop()
}
