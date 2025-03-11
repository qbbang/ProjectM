//
//  AlbumListView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/7/25.
//

import SwiftUI
import MediaPlayerService
import MiniPlayer

struct AlbumListView: View {
    @EnvironmentObject var miniPlayerData: MiniPlayerData
    @StateObject var data: AlbumListData
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            contentsView
                .navigationTitle("라이브러리")
                .navigationBarTitleDisplayMode(.large)
                .toolbar { microphoneBarItem }
        }
    }
    
    // MARK: Private
    @ViewBuilder
    private var contentsView: some View {
        gridView
    }
    
    private var gridView: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(data.albums) { album in
                        NavigationLink(destination: AlbumDetailView(album: album)) {
                            AlbumView(album: album, geometry: geometry)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 16)
                .padding(.bottom, miniPlayerData.miniPlayerHeight + 16)
            }
            
        }
    }
    
    // TODO: 제거하거나 기능을 구현하거나
    private var microphoneBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                print("✅ 녹음 버튼 클릭")
            }) {
                Image(systemName: "microphone.fill")
            }
        }
    }
}

#Preview {
    let miniPlayerData = MiniPlayerData()
    AlbumListView(data: .mock())
        .environmentObject(miniPlayerData)
}
