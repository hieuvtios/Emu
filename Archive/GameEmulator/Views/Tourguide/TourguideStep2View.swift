//
//  TourguideStep2View.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 22/10/25.
//

import SwiftUI

struct TourguideStep2View: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("“Click the Guide tab to see detailed \ninstructions.”")
                .font(Font.custom("Chakra Petch", size: 14))
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(.all, 12)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(hex: "#5392FF"))
                }
            
            Image("arrow")
                .offset(x: -20)
                .scaleEffect(x: 1, y: -1)
            
            Spacer().frame(height: 3)
            
            LottiePlusView(name: "Click here", loopMode: .loop)
                .frame(width: 103, height: 103)
                .scaleEffect(x: 1, y: 1)
                .rotationEffect(.degrees(20))
                .offset(x: -60)
        }
        .offset(y: 40)
    }
}

#Preview {
    TourguideStep2View()
}
