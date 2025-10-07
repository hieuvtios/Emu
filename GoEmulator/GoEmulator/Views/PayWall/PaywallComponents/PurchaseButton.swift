//
//  PurchaseButton.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct PurchaseButton: View {
    let price: String
    let packageName: String
    var showBadge: Bool = false
    
    var body: some View {
        Button {
            
        } label: {
            VStack(alignment: .leading) {
                Text(price)
                    .font(Font.custom("SVN-Determination Sans", size: 24))
                    .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(packageName)
                    .font(
                        Font.custom("Chakra Petch", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 24)
            .padding(.top, 4)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity)
            .background(
                Image("pw_purchase_button")
                    .resizable()
            )
            .cornerRadius(8)
            .overlay(alignment: .topTrailing) {
                Image("pw_badge")
                    .padding(.trailing, 7)
                
            }
        }
    }
}
