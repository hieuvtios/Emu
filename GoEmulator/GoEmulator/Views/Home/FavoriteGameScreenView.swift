//
//  FavoriteGameScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct FavoriteGameScreenView: View {
    var body: some View {
        ZStack {
            AppBackGround()
            
            VStack(spacing: 12) {
                AppTopBar(title: "Favorite")
                
                let height: CGFloat = 79
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(0..<20, id: \.self) { index in
                        RecentGameItem()
                            .frame(height: height)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    FavoriteGameScreenView()
}
