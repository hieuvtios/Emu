//
//  QuickTipAlert.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 22/10/25.
//

import SwiftUI

struct QuickTipAlert: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Image("img_quick_tip")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 254, height: 198)
                
                Spacer().frame(height: 12)
                
                VStack(spacing: 4) {
                    // Title/24px/Bold
                    Text("Quick Tips")
                        .font(Font.custom("Chakra Petch", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Group {
                        // Body/16px/Light
                        Text("Level up your setup — use\n")
                            .font(
                                Font.custom("Chakra Petch", size: 16)
                                    .weight(.light)
                            ) +
                        
                        // Body/16px/Light
                        Text("Controller")
                            .font(
                                Font.custom("Chakra Petch", size: 16)
                                    .weight(.semibold)
                            ) +
                        
                        Text(" and ")
                            .font(
                                Font.custom("Chakra Petch", size: 16)
                                    .weight(.light)
                            ) +
                        
                        Text("AirPlay")
                            .font(
                                Font.custom("Chakra Petch", size: 16)
                                    .weight(.semibold)
                            ) +
                        
                        Text(" together \nfor a true console feel")
                            .font(
                                Font.custom("Chakra Petch", size: 16)
                                    .weight(.light)
                            )
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                    .frame(maxWidth: .infinity, alignment: .top)
                }
                
                Spacer().frame(height: 24)
                
                AppButton(title: "DONE") {
                    
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 24)
            .background(
                ZStack(alignment: .top) {
                    Color(red: 0.05, green: 0.2, blue: 0.53)
                    
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
    QuickTipAlert()
}
