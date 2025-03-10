//
//  MediaItem.swift
//  MediaPlayerService
//
//  Created by MK-AM16-009 on 3/9/25.
//

import SwiftUI
@preconcurrency import MediaPlayer

public struct MediaItem: Identifiable, Sendable {
    public let id: MPMediaEntityPersistentID
    public let title: String
    public let artist: String
    public let artwork: Image?
    public let playbackDuration: TimeInterval?
    public let original: MPMediaItem
    
    
    init(from mediaItem: MPMediaItem) {
        self.id = mediaItem.persistentID
        self.title = mediaItem.title ?? "Unknown"
        self.artist = mediaItem.artist ?? "Unknown"
        let uiImage = mediaItem.artwork?.image(at: CGSize(width: 400, height: 400))
        self.artwork = uiImage != nil ? Image(uiImage: uiImage!) : nil
        self.playbackDuration = mediaItem.playbackDuration
        self.original = mediaItem
    }
    
    public init(id: MPMediaEntityPersistentID, title: String, original: MPMediaItem) {
        self.id = id
        self.title = title
        self.artist = "Unknown"
        self.artwork = nil
        self.playbackDuration = nil
        self.original = original
    }
    
    var originalObject: MPMediaItem {
        return original
    }
}
