//
//  MediaItemCollection.swift
//  MediaPlayerService
//
//  Created by MK-AM16-009 on 3/9/25.
//

import SwiftUI
@preconcurrency import MediaPlayer

public struct MediaItemCollection: Identifiable, Sendable {
    /// collection.representativeItem?.albumPersistentID가 있지만 nullable 함.
    public let id = UUID()
    public let title: String
    public let artist: String
    public let artwork: Image?
    public let items: [MediaItem]
    /// 재생을 위해 필요한대 Sendable를 따르지 않음..
    public let original: MPMediaItemCollection
    
    init(from collection: MPMediaItemCollection) {
        self.title = collection.representativeItem?.albumTitle ?? "Unknown"
        self.artist = collection.representativeItem?.artist ?? "Unknown"
        let uiImage = collection.representativeItem?.artwork?.image(at: CGSize(width: 400, height: 400))
        self.artwork = uiImage != nil ? Image(uiImage: uiImage!) : nil
        self.items = collection.items.enumerated().map { MediaItem(from: $0.element, position: $0.offset + 1) }
        self.original = collection
    }
    
    public init(title: String, artist: String, artwork: Image?, items: [MediaItem]) {
        self.title = title
        self.artist = artist
        self.artwork = artwork
        self.items = items
        self.original = MPMediaItemCollection(items: [])
    }
    
}
