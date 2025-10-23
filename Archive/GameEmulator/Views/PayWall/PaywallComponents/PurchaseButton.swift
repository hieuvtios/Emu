//
//  PurchaseButton.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI
import RevenueCat

struct PurchaseButton: View {
    let package: Package
    var isShowBadge: Bool
    let onTapAction: () -> ()
    
    var body: some View {
        Button {
            onTapAction()
        } label: {
            VStack(alignment: .leading) {
                Text(package.localizedPriceString)
                    .font(Font.custom("SVN-Determination Sans", size: 24))
                    .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(package.storeProduct.localizedTitle)
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
                if isShowBadge {
                    Image("pw_badge")
                        .padding(.trailing, 7)
                }
            }
        }
    }
}
