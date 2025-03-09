//
//  File.swift
//  MediaPlayerService
//
//  Created by MK-AM16-009 on 3/8/25.
//

import MediaPlayer

extension MPMediaItem {
    /// 고유한 값이 없어 조합보다는 새로 생성해서 처리
    public var id: String {
        return UUID().uuidString
    }
}
