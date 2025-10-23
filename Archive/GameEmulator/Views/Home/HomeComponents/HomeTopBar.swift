//
//  HomeTopBar.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 3/10/25.
//

import SwiftUI

struct HomeTopBar: View {
    
    let title: String
    
    @State private var showIAPView = false
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(Font.custom("SVN-Determination Sans", size: 32))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Spacer()
            
            if !UserDefaultsManager.shared.isPurchased {
                Button {
                    showIAPView = true
                } label: {
                    Image("home_crown")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .center)
        .fullScreenCover(isPresented: $showIAPView) {
            PayWallScreenView()
        }
    }
}
