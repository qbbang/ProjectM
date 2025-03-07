//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/6/25.
//

import SwiftUI
import MediaPlayerService

@main
struct MusicPlayerApp: App {
    private var mediaPlayerService = MediaPlayerService()
    private let navBarAppearence = UINavigationBarAppearance()
    
    init() {
        configureNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            let data = AlbumListData(mediaPlayerService: mediaPlayerService)
            AlbumListView(data: data)
                .task {
                    await data.fetchMediaItems()
                }
        }
    }
    
    private func configureNavigationBarAppearance() {
        let barButtonItemAppearance = UIBarButtonItemAppearance()
        barButtonItemAppearance.normal.titleTextAttributes = [:]
        barButtonItemAppearance.normal.backgroundImage = nil
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = nil
        navigationBarAppearance.backgroundColor = .cyan
        navigationBarAppearance.titleTextAttributes = [:]
        navigationBarAppearance.backButtonAppearance = barButtonItemAppearance
        navigationBarAppearance.setBackIndicatorImage(nil, transitionMaskImage: nil)
        
        let appearance = UINavigationBar.appearance()
        /// UIHostingController를 감싸서 화면전환 시 기본 백버튼이 노출되어 .clear 적용
        appearance.tintColor = .clear
        appearance.standardAppearance = navigationBarAppearance
        appearance.scrollEdgeAppearance = navigationBarAppearance
        appearance.compactAppearance = navigationBarAppearance
        appearance.compactScrollEdgeAppearance = navigationBarAppearance
    }
}
