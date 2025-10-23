//
//  TourguideStep1View.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 22/10/25.
//

import SwiftUI

struct TourguideStep1View: View {
    var body: some View {
        VStack(spacing: 0) {
            LottiePlusView(name: "Click here", loopMode: .loop)
                .frame(width: 103, height: 103)
                .scaleEffect(x: -1, y: -1)
                .offset(x: -40)
            
            Spacer().frame(height: 3)
            
            Image("arrow")
                .offset(x: -40)
            
            Text("✋ Hello friend, “we’ve created a game \nthat could make things easier”")
                .font(Font.custom("Chakra Petch", size: 14))
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(.all, 12)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(hex: "#5392FF"))
                }
        }
        .offset(y: -60)
    }
}

#Preview {
    TourguideStep1View()
}
