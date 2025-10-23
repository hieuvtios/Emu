//
//  PreparingGameAlert.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 22/10/25.
//

import SwiftUI

struct PreparingGameAlert: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {

                Image("img_prepare")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 178, height: 147)
                
                Text("Preparing your game... Hang \ntight!")
                    .font(Font.custom("Chakra Petch", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                LottiePlusView(name: "loading_gray", loopMode: .loop)
                    .frame(width: 56, height: 56)
                    .padding(.vertical)
                
                Button {
                    
                } label: {
                    Image("ob_button_4")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Text("CANCEL")
                                .font(Font.custom("SVN-Determination Sans", size: 20))
                                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 9)
            .padding(.bottom, 21)
            .background(
                Color(red: 0.05, green: 0.2, blue: 0.53)
            )
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    PreparingGameAlert()
}
