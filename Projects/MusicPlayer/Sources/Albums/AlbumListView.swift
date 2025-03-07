//
//  AlbumListView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/7/25.
//

import SwiftUI
import MediaPlayer

struct AlbumListView: View {
    @StateObject var data: AlbumListData
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            contentsView
                .navigationTitle("SwiftUI")
                .navigationBarTitleDisplayMode(.large)
                .toolbar { microphoneBarItem }
        }
    }
    
    // MARK: Private
    @ViewBuilder
    private var contentsView: some View {
        
        if data.albums.isEmpty {
            ProgressView("Loading...")
                .frame(width: 150, height: 150)
        } else {
            gridView
        }
    }
    
    @ViewBuilder
    private var gridView: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(data.albums, id: \.id) { album in
                        AlbumView(album: album, geometry: geometry)
                            .onTapGesture {
                                Task {
                                    await data.testPlay(album: album.mediaItem)
                                }
                                print("✅ 앨범 클릭: \(album.title)")
                            }
                    }
                }
                .padding()
            }
        }
    }
    
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
