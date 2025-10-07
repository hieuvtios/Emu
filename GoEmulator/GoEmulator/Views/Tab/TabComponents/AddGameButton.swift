//
//  AddButton.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 5/10/25.
//

import SwiftUI

struct AddGameButton: View {
    
    @Binding var isExpanded: Bool
    
    var backgroundColor: LinearGradient {
        if !isExpanded {
            return LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.86, green: 0.41, blue: 0), location: 0.00),
                    Gradient.Stop(color: Color(red: 1, green: 0.73, blue: 0.04), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.51, y: 1),
                endPoint: UnitPoint(x: 0.51, y: 0)
            )
        } else {
            return LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 1, green: 0.5, blue: 0.55), location: 0.00),
                    Gradient.Stop(color: Color(red: 1, green: 0.15, blue: 0.23), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        }
    }
    
    var icon: String {
        if !isExpanded {
            return "add"
        } else {
            return "Times"
        }
    }
    
    var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            Image("tab_add_game")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70, alignment: .center)
                .background(
                    backgroundColor
                )
                .cornerRadius(100)
                .shadow(color: Color(red: 0.95, green: 0.62, blue: 0.02).opacity(0.5), radius: 15, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .inset(by: -0.5)
                        .stroke(Color(red: 1, green: 0.94, blue: 0.31), lineWidth: 1)
                )
                .overlay {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
        }
    }
}
