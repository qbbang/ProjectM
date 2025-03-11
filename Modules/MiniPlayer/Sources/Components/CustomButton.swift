//
//  CustomButton.swift
//  MiniPlayer
//
//  Created by MK-AM16-009 on 3/10/25.
//

import SwiftUI

struct CustomButton: View {
    let action: () async -> Void
    let imageName: String
    let width: CGFloat = 40
    let height: CGFloat = 40
    let tintColor: Color = .black
    
    var body: some View {
        Button(action: {
            Task {
                await action()
            }
        }) {
            Image(systemName: imageName)
                .padding()
                .tint(tintColor)
        }
        .frame(width: width, height: height)
        .background(Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
        HStack {
            let width: CGFloat = 40
            let height: CGFloat = 40
            CustomButton(action: {
                print("action")
            }, imageName: "repeat")
            
        }
    }
    .ignoresSafeArea()
}
