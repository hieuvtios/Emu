//
//  RecentGameItem.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct RecentGameItem: View {
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: 79)
            
            HStack(spacing: 4) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Pokemon - Ruby Version")
                        .font(
                            Font.custom("Chakra Petch", size: 14)
                                .weight(.bold)
                        )
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("GBA - Game Freak")
                        .font(Font.custom("Inter", size: 10))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    
                } label: {
                    Image("home_ic_more")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
            }
            .padding(8)
        }
        .cornerRadius(8)
    }
}

#Preview {
    TabScreenView()
}
