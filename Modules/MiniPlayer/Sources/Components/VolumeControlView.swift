//
//  VolumeControlView.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/11/25.
//

import SwiftUI

struct VolumeControlView: View {
    @ObservedObject var controlData: MiniPlayerControlData
    
    var body: some View {
        HStack {
            Image(systemName: "speaker.fill").foregroundColor(.white)
            Slider(
                value: Binding(
                    get: { Double(controlData.volume) },
                    set: { newValue in
                        controlData.volume = Float(newValue)
                        controlData.setSystemVolume(volume: Float(newValue))
                    }
                ),
                in: 0...1,
                step: 0.01
            )
            .accentColor(.white)
            Image(systemName: "speaker.wave.3.fill").foregroundColor(.white)
        }
        .padding(.top, 20)
    }
}
