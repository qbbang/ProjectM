//
//  MiniPlayerDetailControlData.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/11/25.
//

import SwiftUI
import Combine
import AVFAudio
import MediaPlayer

class MiniPlayerControlData: ObservableObject {
    @Published var sliderValue: Double = 0
    @Published var isDragging: Bool = false
    @Published var isSeeking: Bool = false
    @Published var volume: Float = AVAudioSession.sharedInstance().outputVolume
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupVolumeObserver()
    }
    
    func setupVolumeObserver() {
        NotificationCenter.default.publisher(for: NSNotification.Name("AVSystemController_SystemVolumeDidChangeNotification"))
            .sink { [weak self] _ in
                let audioSession = AVAudioSession.sharedInstance()
                self?.volume = audioSession.outputVolume
            }
            .store(in: &cancellables)
    }
    
    func setSystemVolume(volume: Float) {
        let volumeView = MPVolumeView()
        if let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            DispatchQueue.main.async {
                slider.value = volume
            }
        }
    }
}
