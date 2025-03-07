//
//  AlbumDisplayItem.swift
//  MediaPlayerService
//
//  Created by MK-AM16-009 on 3/7/25.
//

import Foundation
import MediaPlayer
import SwiftUI

public struct AlbumDisplayItem: Identifiable, @unchecked Sendable {
    public let id = UUID()
    public let title: String
    public let artist: String
    public let artwork: Image?
    
    /// 재생을 위해 필요한대 Sendable를 따르지 않음..
    public let mediaItem: MPMediaItemCollection
    
    init(from mediaItem: MPMediaItemCollection) {
        self.title = mediaItem.representativeItem?.albumTitle ?? "Unknown"
        self.artist = mediaItem.representativeItem?.artist ?? "Unknown"
        let uiImage = mediaItem.representativeItem?.artwork?.image(at: CGSize(width: 400, height: 400))
        self.artwork = uiImage != nil ? Image(uiImage: uiImage!) : nil
        self.mediaItem = mediaItem
    }
}
