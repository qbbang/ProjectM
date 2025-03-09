//
//  AlbumDetailView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/8/25.
//

import SwiftUI
import MediaPlayerService

struct AlbumDetailView: View {
    // TODO: matchedGeometryEffect 활용한 셔플 애니메이션 다시 할 것
    // @Namespace private var animation
    @State private var isPlaying = false
    @State private var buttonImage = "play.fill"
    
    @ObservedObject var data: AlbumDetailData
    
    var body: some View {
        VStack(spacing: 0) {
            contentView
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    // MARK: Private
    @ViewBuilder
    private var contentView: some View {
        VStack {
            albumInfoView
        }
        Spacer(minLength: 16)
        soungList
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
            ActionButtonView(
                width: (geometry.size.width / 2) - 4,
                buttonImage: buttonImage,
                onPlayPauseToggle: {
                    if isPlaying {
                        Task { await data.pause() }
                        buttonImage = "play.fill"
                    } else {
                        Task { await data.play() }
                        buttonImage = "pause.fill"
                    }
                    isPlaying.toggle()
                },
                onShuffle: {
                    Task { @MainActor in
                        Task { await data.shuffle() }
                    }
                }
            )
        }
        .frame(height: 60)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private var soungList: some View {
        ScrollView {
            soungRow
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange)
                .shadow(radius: 5)
                .padding(.horizontal, 16)
        )
    }
    
    private var soungRow: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 8)
            
            ForEach(data.soungs, id: \.id) { soung in
                Label(soung.title ?? "ss", systemImage: "music.note")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
            }
        }
        .padding()
    }
}

#Preview {
    AlbumDetailView(data: .mock())
}
