//
//  HomeFavoriteView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct HomeFavorite: View {
    var body: some View {
        VStack(spacing: 16) {
            HomeTopTitle(title: "Favourite")
            
            let width: CGFloat = 96
            let height: CGFloat = 96
            ScrollView(.horizontal, showsIndicators: false) {
                
                LazyHStack(spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        FavoriteGameItem()
                            .frame(width: width, height: height)
                    }
                }
            }
            .frame(height: height)
        }
    }
}

#Preview {
    HomeFavorite()
}
