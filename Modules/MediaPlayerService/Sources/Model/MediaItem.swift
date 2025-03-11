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
    public var isPlaying: Bool
    public let positionl: Int
    public let original: MPMediaItem
    
    public init(from mediaItem: MPMediaItem, position: Int) {
        self.id = mediaItem.persistentID
        self.title = mediaItem.title ?? "Unknown"
        self.artist = mediaItem.artist ?? "Unknown"
        let uiImage = mediaItem.artwork?.image(at: CGSize(width: 400, height: 400))
        self.artwork = uiImage != nil ? Image(uiImage: uiImage!) : nil
        self.playbackDuration = mediaItem.playbackDuration
        self.isPlaying = false
        self.positionl = position
        self.original = mediaItem
    }
    
    public init(id: MPMediaEntityPersistentID, title: String, artist: String, artwork: Image?, playbackDuration: TimeInterval?, isPlaying: Bool, positionl: Int, original: MPMediaItem) {
        self.id = id
        self.title = title
        self.artist = artist
        self.artwork = artwork
        self.playbackDuration = playbackDuration
        self.isPlaying = isPlaying
        self.positionl = positionl
        self.original = original
    }
    
    var originalObject: MPMediaItem {
        return original
    }
}
