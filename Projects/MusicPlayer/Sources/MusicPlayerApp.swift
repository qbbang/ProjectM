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
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemOrange
        
        let appearance = UINavigationBar.appearance()
        appearance.standardAppearance = navigationBarAppearance
        appearance.scrollEdgeAppearance = navigationBarAppearance
        appearance.compactAppearance = navigationBarAppearance
        appearance.compactScrollEdgeAppearance = navigationBarAppearance
    }
}
