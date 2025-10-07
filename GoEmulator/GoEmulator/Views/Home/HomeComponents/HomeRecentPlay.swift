//
//  HomeRecentPlay.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct HomeRecentPlay: View {
    var body: some View {
        VStack(spacing: 16) {
            HomeTopTitle(title: "Recent Play")
            
            let width: CGFloat = 240
            let height: CGFloat = 96
            
            ScrollView(.horizontal, showsIndicators: false) {
                let rows = Array(repeating: GridItem(.fixed(height), spacing: 12), count: 2)
                
                LazyHGrid(rows: rows, spacing: 40) {
                    ForEach(0..<20, id: \.self) { index in
                        RecentGameItem()
                            .frame(width: width)
                    }
                }
            }
            //.frame(height: height)
        }
    }
}

#Preview {
    TabScreenView()
}
