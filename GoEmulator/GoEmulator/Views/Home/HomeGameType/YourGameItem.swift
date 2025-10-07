//
//  YourGameItem.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct YourGameItem: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
            
            HStack(alignment: .bottom, spacing: 4) {
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
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            .background(Color(red: 0.07, green: 0.24, blue: 0.63))
        }
        .cornerRadius(8)
    }
}

#Preview {
    YourGameItem()
}
