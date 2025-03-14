//
//  AlbumDetailView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/8/25.
//

import SwiftUI
import MediaPlayerService
import MiniPlayer

struct AlbumDetailView: View {
    @Namespace private var animation
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var miniPlayerData: MiniPlayerData
    @StateObject var data: AlbumDetailData
    
    /// https://developer.apple.com/documentation/swiftui/stateobject?utm_source=chatgpt.com#Initialize-state-objects-using-external-data
    init(album: MediaItemCollection) {
        _data = StateObject(wrappedValue: AlbumDetailData(album: album))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            contentView
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .task {
            let mediaItem = miniPlayerData.nowPlayingItem
            await data.sync(mediaItem: mediaItem)
        }
    }
    
    // MARK: Private
    @ViewBuilder
    private var contentView: some View {
        VStack {
            albumInfoView
        }
        Spacer(minLength: 16)
        mediaItemContentView
    }
    
    @ViewBuilder
    private var albumInfoView: some View {
        HStack {
            artworkImageView
            infoView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        
        actionButtons
            .onChange(of: scenePhase) { scenePhase in
                if scenePhase == .active {
                    Task {
                        let mediaItem = miniPlayerData.nowPlayingItem
                        await data.sync(mediaItem: mediaItem)
                    }
                }
            }
    }
    
    @ViewBuilder
    private var artworkImageView: some View {
        if let artworkImage = data.artwork {
            artworkImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(8)
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .cornerRadius(8)
        }
    }
    
    private var infoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(data.title)
                .font(.title2.bold())
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(data.artistName)
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxHeight: 80, alignment: .top)
    }
    
    private var actionButtons: some View {
        GeometryReader { geometry in
            let isCurrentAlbumPlaying = miniPlayerData.isPlayingAlbum(data.album)
            
            ActionButtonView(
                width: (geometry.size.width / 2) - 4,
                buttonImage: isCurrentAlbumPlaying ? "pause.fill" : "play.fill",
                onPlayPauseToggle: {
                    if isCurrentAlbumPlaying {
                        await data.pause()
                    } else {
                        await data.play()
                    }
                },
                onShuffle: {
                    await data.shufflePlay()
                    let nowPlayingItem = miniPlayerData.nowPlayingItem
                    for await item in miniPlayerData.nowPlayingItemStream {
                        if nowPlayingItem?.id != item?.id {
                            await data.sync(mediaItem: item)
                            break
                        }
                    }
                }
            )
        }
        .frame(height: 60)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private var mediaItemContentView: some View {
        ScrollView {
            mediaItemListView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange)
                .shadow(radius: 5)
                .padding(.horizontal, 16)
        )
    }
    
    private var mediaItemListView: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 8)
            ForEach(data.mediaItems, id: \.id) { mediaItem in
                MediaItemTitleView(namespace: animation, mediaItem: mediaItem)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                    .onTapGesture {
                        Task { await data.play(mediaItem: mediaItem) }
                    }
            }
        }
        .padding()
        .onChange(of: miniPlayerData.nowPlayingItem) { newItem in
            Task { await data.sync(mediaItem: newItem) }
        }
    }
}

#Preview {
    let items = [
        MediaItem(
            id: 231,
            title: "title",
            artist: "artist",
            artwork: nil,
            playbackDuration: 180,
            isPlaying: true,
            positionl: 0,
            original: .init()
        )
    ]
    let album = MediaItemCollection(title: "title", artist: "artist", artwork: nil, items: items)
    AlbumDetailView(album: album)
        .environmentObject(MiniPlayerData())
}
