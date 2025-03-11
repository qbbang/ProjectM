//
//  FloatingPoint+.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/10/25.
//

import Foundation

extension FloatingPoint {
    func isApproximatelyEqual(to other: Self, tolerance: Self) -> Bool {
        abs(self - other) <= tolerance
    }
}
