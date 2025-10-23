//
//  SettingPremiumBanner.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct SettingPremiumBanner: View {
    
    let features = [
        "FREE all legendary games",
        "Unlimited premium features",
        "Remove all interruptive ads",
        "Multi-function support"
    ]
    
    var onTapAction: () -> ()
    
    var body: some View {
        Image("setting_premium_bg")
            .resizable()
            .scaledToFit()
            .overlay {
                HStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        HStack(spacing: -1) {
                            Text("GBA emulator")
                                .font(Font.custom("SVN-Determination Sans", size: 24))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            
                            VStack(spacing: -8) {
                                Image("Group 1")
                                
                                Image("Group")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 18)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(features, id: \.self) {
                                string in
                                HStack(alignment: .center, spacing: 6.49123) {
                                    Image("Star")
                                    
                                    Text(string)
                                        .font(
                                            Font.custom("Chakra Petch", size: 10)
                                                .weight(.bold)
                                        )
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    }
                    
                    Spacer()
                    
                    Button {
                        onTapAction()
                    } label: {
                        Text("Ugrade now")
                          .font(
                            Font.custom("Chakra Petch", size: 16)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.54, green: 0.09, blue: 0.61))
                          .padding(.horizontal, 16)
                          .padding(.vertical, 2)
                          .frame(width: 132, height: 32, alignment: .center)
                          .background(Color(red: 0.94, green: 0.69, blue: 0.98))
                          .cornerRadius(42)
                    }
                    .padding(.trailing, 14)
                    .overlay(alignment: .topLeading) {
                        Image("home_crown")
                            .rotationEffect(Angle(degrees: -39))
                            .offset(x: -20, y: -20)
                    }
                }
            }
    }
}
