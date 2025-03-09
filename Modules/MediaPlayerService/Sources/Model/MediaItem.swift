//
//  MediaItem.swift
//  MediaPlayerService
//
//  Created by MK-AM16-009 on 3/9/25.
//

@preconcurrency import MediaPlayer

public struct MediaItem: Identifiable, Sendable {
    public let id: MPMediaEntityPersistentID
    public let title: String
    public let original: MPMediaItem

    init(from mediaItem: MPMediaItem) {
        self.id = mediaItem.persistentID
        self.title = mediaItem.title ?? "Unknown"
        
        self.original = mediaItem
    }
    
    var originalObject: MPMediaItem {
        return original
    }
}
