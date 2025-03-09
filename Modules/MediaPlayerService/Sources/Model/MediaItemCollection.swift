//
//  MediaItemCollection.swift
//  MediaPlayerService
//
//  Created by MK-AM16-009 on 3/9/25.
//

import MediaPlayer

public struct MediaItemCollection {
    public let mediaItemCollection: MPMediaItemCollection
    
    public init(mediaItemCollection: MPMediaItemCollection) {
        self.mediaItemCollection = mediaItemCollection
    }
}
