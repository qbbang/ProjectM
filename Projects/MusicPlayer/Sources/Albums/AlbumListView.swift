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
            // FIXME: NSBundle file:///System/Library/PrivateFrameworks/MetalTools.framework/ principal class is nil because all fallbacks have failed
            // <0x101d6df40> Gesture: System gesture gate timed out.
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(data.albums, id: \.uuid) { album in
                        AlbumView(album: album, geometry: geometry)
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
