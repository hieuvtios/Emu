//
//  HomeEmptyList.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 3/10/25.
//

import SwiftUI

struct HomeEmptyList: View {
    var body: some View {
        VStack(spacing: 16) {
            
            Image("home_empty_list")
                .resizable()
                .scaledToFit()
                .frame(width: 208, height: 171)
            
            VStack(spacing: 8) {
                Text("NO GAME YET")
                    .font(Font.custom("SVN-Determination Sans", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .top)
                
                // Caption/12px/Regular
                Text("Add a game to keep up with your progress, get \ntimely updates, and enjoy tailored \nrecommendations.")
                    .font(Font.custom("Chakra Petch", size: 12))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.grey300))
                    .frame(maxWidth: .infinity, alignment: .top)
            }
        }
    }
}

#Preview {
    HomeEmptyList()
}
