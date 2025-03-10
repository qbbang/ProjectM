//
//  MeualAuthorizationView.swift
//  MusicPlayer
//
//  Created by MK-AM16-009 on 3/10/25.
//

import SwiftUI

struct MeualAuthorizationView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image("mediaPermissionGuide")
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
            Text("앱 사용을 위해서는 음악 접근 권한이 필요합니다.")
            
            Button("설정으로 이동") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

#Preview {
    MeualAuthorizationView()
}
