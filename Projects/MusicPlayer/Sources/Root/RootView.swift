//
//  RootView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/10/25.
//

import SwiftUI
@preconcurrency import MediaPlayerService

/// 미디어 접근권한 없이 사용할 수 없기 때문에 접근권한에 따라 노출하는 화면이 달라진다.
struct RootView: View {
    @State var isAuthorized: Bool? = nil
    
    var body: some View {
        VStack {
            contentView
        }
        .task {
            let authorization = await MediaPlayerService.shared.requestAuthorization()
            if authorization == .authorized {
                isAuthorized = true
            } else {
                isAuthorized = false
            }
        }
    }
    
    private var contentView: some View {
        ZStack {
            if isAuthorized == nil{
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
        AlbumListView(data: data).task {
            await data.fetchMediaItems()
        }
    }
}

#Preview {
    RootView(isAuthorized: true)
}
