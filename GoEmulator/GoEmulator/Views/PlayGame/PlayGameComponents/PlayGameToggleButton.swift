//
//  PlayGameToggleButton.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct PlayGameToggleButton: View {
    
    @State var toggle = true
    
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            
            Text(title)
                .font(
                    Font.custom("Chakra Petch", size: 16)
                        .weight(.bold)
                )
                .foregroundColor(Color(red: 0.96, green: 0.97, blue: 1))
            
            Toggle("", isOn: $toggle)
                .tint(Color(red: 0.94, green: 0.69, blue: 0.98))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.37, green: 0.36, blue: 1), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.17, green: 0.26, blue: 1), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.32, y: 0.07),
                endPoint: UnitPoint(x: 0.66, y: 0.88)
            )
            .opacity(0.2)
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .inset(by: 1)
                .stroke(Color(red: 0.6, green: 0.71, blue: 0.98), lineWidth: 2)
        )
    }
}
