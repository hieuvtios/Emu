//
//  MenuButton.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct MenuButton: View {
    
    @State var toggle: Bool = true
    let gameMenu: GameMenuEnum
    let buttonType: ButtonType
    var isShowCrown: Bool = false
    let onTapAction: () -> ()
    
    var body: some View {
        Button {
            onTapAction()
        } label: {
            HStack(alignment: .center, spacing: 8) {
                Image(gameMenu.icon)
                
                // Body/16px/Medium
                Text(gameMenu.title)
                    .font(
                        Font.custom("Chakra Petch", size: 16)
                            .weight(.medium)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                if isShowCrown {
                    Image("home_crown")
                }
                
                if buttonType == .type2 {
                    // Caption/12px/Bold
                    Text("NEW")
                        .font(
                            Font.custom("Chakra Petch", size: 12)
                                .weight(.bold)
                        )
                        .foregroundColor(Color(red: 0.45, green: 0.01, blue: 0.01))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 1, green: 0.84, blue: 0.35), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.93, green: 0.55, blue: 0.02), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            )
                        )
                        .cornerRadius(4)
                } else if buttonType == .type3 {
                    Toggle("", isOn: $toggle)
                        .tint(Color(red: 0.94, green: 0.69, blue: 0.98))
                }
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
