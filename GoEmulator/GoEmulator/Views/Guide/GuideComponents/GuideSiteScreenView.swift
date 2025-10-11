//
//  GuideSiteScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 8/10/25.
//

import SwiftUI

struct GuideSiteScreenView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                Group {
                    Text("*Disclaimer: ")
                      .font(Font.custom("SVN-Determination Sans", size: 14))
                      .foregroundColor(Color(red: 0.94, green: 0.27, blue: 0.27)) +
                    
                    Text("The websites listed below are user-recommended. We are not affiliated with their content and do not take responsibility for any issues or copyright concerns that may arise from downloads. Please proceed at your own discretion.")
                      .font(Font.custom("SVN-Determination Sans", size: 14))
                      .foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    siteItem(image: "Frame 2084", text: "emulatorgames.net")
                    
                    siteItem(image: "Frame 2083", text: "wowroms.com")
                    
                    siteItem(image: "Frame 2082", text: "retrostic.com")
                    
                    siteItem(image: "Frame 2084", text: "Romsfun.com")
                }
            }
        }
    }
    
    @ViewBuilder
    func siteItem(image: String, text: String) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Image(image)
                .resizable()
                .scaledToFit()
            
            Text(text)
                .font(Font.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.87, green: 0.96, blue: 1))
        }
        .padding(0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    GuideSiteScreenView()
}
