//
//  HomeGameList.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 4/10/25.
//

import SwiftUI

struct HomeGameList: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                HomeRecentPlay()
                
                HomeFavorite()
                
                HomeTopTitle(title: "Your  Game")
                
                HomeCategory()
                
                let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
                let height: CGFloat = 237
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(0..<6, id: \.self) { index in
                        YourGameItem()
                            .frame(height: height)
                    }
                }
            }
            
            Spacer().frame(height: 100)
        }
//        .overlay {
//            HomeEmptyList()
//                .offset(y: -40)
//        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
}

#Preview {
    TabScreenView()
}
