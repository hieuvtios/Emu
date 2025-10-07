//
//  PayWallScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI

struct PayWallScreenView: View {

    var body: some View {
        ZStack {
            Image("pw_bg")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                FeatureView()
                
                VStack(spacing: 16) {
                    FreeTrialPurchaseButton()
                    
                    PurchaseButton(price: "99.000 đ", packageName: "Weekly - Weekly Promo")
                    
                    PurchaseButton(price: "99.000 đ", packageName: "Weekly - Weekly Promo")
                }
                .padding(.leading, 16)
                .padding(.trailing, 25)
                
                HStack(spacing: 16) {
                    Button {
                        
                    } label: {
                        // Caption/12px/Bold
                        Text("Cancel Anytime")
                          .font(
                            Font.custom("Chakra Petch", size: 12)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.87, green: 0.96, blue: 1))
                    }
                    
                    Button {
                        
                    } label: {
                        // Caption/12px/Bold
                        Text("Terms and Condition")
                          .font(
                            Font.custom("Chakra Petch", size: 12)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.87, green: 0.96, blue: 1))
                    }
                    
                    Button {
                        
                    } label: {
                        // Caption/12px/Bold
                        Text("Privacy Policy")
                          .font(
                            Font.custom("Chakra Petch", size: 12)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.87, green: 0.96, blue: 1))
                    }
                    
                }
            }
            
        }
    }
}

#Preview {
    PayWallScreenView()
}
