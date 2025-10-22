//
//  SwiftUIView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 22/10/25.
//

import SwiftUI

struct TourguideStep3View: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("“Click the button below to add a game.”")
                .font(Font.custom("Chakra Petch", size: 14))
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(.all, 12)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(hex: "#5392FF"))
                }
            
            Image("arrow")
                .offset(x: 0)
                .scaleEffect(x: 1, y: -1)
            
            Spacer().frame(height: 3)
            
            LottiePlusView(name: "Click here", loopMode: .loop)
                .frame(width: 103, height: 103)
                .scaleEffect(x: 1, y: 1)
                .rotationEffect(.degrees(0))
                .offset(x: 0)
            
            Spacer().frame(height: 130)
            
            SemiCircleTabBar(isExpanded: .constant(true), addGameAction: { _ in })
                .disabled(true)
        }
        .offset(y: 85)
    }
}

#Preview {
    TourguideStep3View()
}
