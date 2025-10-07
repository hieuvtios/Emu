//
//  AppBannerNotification.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI

struct AppBannerNotification: View {
    
    let title: String
    let subTitle: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image("Check Circle")
            
            VStack(spacing: 0) {
                // Body/16px/Bold
                Text(title)
                    .font(
                        Font.custom("Chakra Petch", size: 16)
                            .weight(.bold)
                    )
                    .foregroundColor(Color(red: 0, green: 0.8, blue: 0.6))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Caption/12px/Regular
                Text(subTitle)
                    .font(Font.custom("Chakra Petch", size: 12))
                    .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
        .padding(.leading, 18)
        .frame(height: 72)
        .background(Color(red: 0.96, green: 1, blue: 0.99))
        .cornerRadius(7.58397)
        .overlay(alignment: .leading) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 4, height: 72)
                .background(Color(red: 0, green: 0.8, blue: 0.6))
                .cornerRadius(3.79198)
        }
        .padding(.horizontal, 20)
    }
}

