//
//  RootView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/10/25.
//

import SwiftUI
import MiniPlayer

/// 미디어 접근권한 없이 사용할 수 없기 때문에 접근권한에 따라 노출하는 화면이 달라진다.
struct RootView: View {
    @StateObject private var miniPlayerData = MiniPlayerData()
    @State private var isAuthorized: Bool? = nil
    
    var body: some View {
        VStack {
            contentView
        }
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            let authorization = await miniPlayerData.requestAuthorization()
            isAuthorized = (authorization == .authorized)
        }
    }
    
    private var contentView: some View {
        ZStack {
            if isAuthorized == nil {
                launchView
            } else if isAuthorized ?? false {
                mainView
            } else {
                MeualAuthorizationView()
            }
        }
    }
    
    private var launchView: some View {
        Image("LaunchImage")
    }
    
    @ViewBuilder
    private var mainView: some View {
        let data = AlbumListData()
        let albumListView = AlbumListView(data: data).task {
            let albumList = await data.fetchAlbumList()
            await miniPlayerData.fetched(albumList)
        }
        
        MusicPlayerContainerView(content: albumListView)
            .environmentObject(miniPlayerData)
    }
}

#Preview {
    RootView()
        .environmentObject(MiniPlayerData())
}
