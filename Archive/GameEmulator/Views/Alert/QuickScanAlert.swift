//
//  QuickScanAlert.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct QuickScanAlert: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image("home_ic_close")
                            .padding()
                    }
                }
                
                Image("Group 34084")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 251.87825, height: 173.61726)
                
                Spacer().frame(height: 16)
                
                VStack(spacing: 4) {
                    // Title/24px/Bold
                    Text("10 new games")
                        .font(Font.custom("Chakra Petch", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Body/16px/Light
                    Text("We've add new games for you! \n10 game just have been added into your New Games list")
                        .font(
                            Font.custom("Chakra Petch", size: 16)
                                .weight(.light)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                        .frame(maxWidth: .infinity, alignment: .top)
                }
                
                Spacer().frame(height: 24)
                
                AppButton(title: "LET’S PLAY") {
                    
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 24)
            .background(
                ZStack(alignment: .top) {
                    Color(red: 0.05, green: 0.2, blue: 0.53)
                    
                    Image("Frame")
                        .resizable()
                        .scaledToFit()
                    
                    Image("Group 34047")
                        .resizable()
                        .scaledToFit()
                    
                }
            )
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    QuickScanAlert()
}
