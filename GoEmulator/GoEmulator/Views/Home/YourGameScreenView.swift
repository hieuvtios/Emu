//
//  YourGameScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct YourGameScreenView: View {
    var body: some View {
        ZStack {
            AppBackGround()
            
            VStack(spacing: 16) {
                AppTopBar(title: "Your Game")
                
                HomeCategory()
                    .padding(.leading, 20)
                
                let height: CGFloat = 79
                
                ScrollView(.vertical, showsIndicators: false) {
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
                    let height: CGFloat = 237
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(0..<20, id: \.self) { index in
                            YourGameItem()
                                .frame(height: height)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    YourGameScreenView()
}
