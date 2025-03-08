//
//  AlbumDisplayItem.swift
//  MediaPlayerService
//
//  Created by MK-AM16-009 on 3/7/25.
//

import SwiftUI
import MediaPlayer

public struct AlbumDisplayItem: Identifiable, @unchecked Sendable {
    public let id = UUID()
    public let title: String
    public let artist: String
    public let artwork: Image?
    
    /// 재생을 위해 필요한대 Sendable를 따르지 않음..
    public let mediaItemCollection: MPMediaItemCollection
    
    init(from mediaItemCollection: MPMediaItemCollection) {
        self.title = mediaItemCollection.representativeItem?.albumTitle ?? "Unknown"
        self.artist = mediaItemCollection.representativeItem?.artist ?? "Unknown"
        let uiImage = mediaItemCollection.representativeItem?.artwork?.image(at: CGSize(width: 400, height: 400))
        self.artwork = uiImage != nil ? Image(uiImage: uiImage!) : nil
        self.mediaItemCollection = mediaItemCollection
    }
    
    public init(title: String, artist: String, artwork: Image?, mediaItemCollection: MPMediaItemCollection) {
        self.title = title
        self.artist = artist
        self.artwork = artwork
        self.mediaItemCollection = mediaItemCollection
    }
}
