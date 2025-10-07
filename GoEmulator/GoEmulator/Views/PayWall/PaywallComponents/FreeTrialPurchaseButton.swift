//
//  FreeTrialButton.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct FreeTrialPurchaseButton: View {
    var body: some View {
        Button {
            
        } label: {
            VStack {
                Text("3- DAY FREE TRIAL")
                    .font(Font.custom("SVN-Determination Sans", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Text("Then payment 599.000 đ per year")
                    .font(
                        Font.custom("Chakra Petch", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
            }
            .padding(.horizontal, 32)
            .padding(.top, 4)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 68)
            .background(
                Image("pw_purchase_button_free_trial")
                    .resizable()
            )
            .cornerRadius(8)
        }
    }
}

#Preview {
    FreeTrialPurchaseButton()
}
