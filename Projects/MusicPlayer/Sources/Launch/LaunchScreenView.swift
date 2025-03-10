//
//  LaunchScreenView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/10/25.
//

import SwiftUI
@preconcurrency import MediaPlayerService

struct LaunchScreenView: View {
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
                Image("LaunchImage")
            } else if isAuthorized ?? false {
                let data = AlbumListData()
                AlbumListView(data: data).task {
                    await data.fetchMediaItems()
                }
            } else {
                MeualAuthorizationView()
            }
        }
    }
}

#Preview {
    LaunchScreenView(isAuthorized: true)
}
