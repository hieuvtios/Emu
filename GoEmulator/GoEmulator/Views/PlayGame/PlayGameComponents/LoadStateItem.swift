//
//  LoadStateItem.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct LoadStateItem: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Rectangle()
                .frame(width: 60, height: 60)
                .cornerRadius(4)
            
            VStack(alignment: .leading, spacing: 4) {
                // Body/16px/Bold
                Text("Save slot 1")
                    .font(
                        Font.custom("Chakra Petch", size: 16)
                            .weight(.bold)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                // Caption/12px/Regular
                Text("12:28 - 27/03/2025")
                    .font(Font.custom("Chakra Petch", size: 12))
                    .foregroundColor(Color(red: 0.33, green: 0.57, blue: 1))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                // Caption/12px/Medium
                Text("Delete")
                    .font(
                        Font.custom("Chakra Petch", size: 12)
                            .weight(.medium)
                    )
                    .underline()
                    .foregroundColor(Color(red: 0.94, green: 0.27, blue: 0.27))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.07, green: 0.24, blue: 0.63).opacity(0.5))
        .cornerRadius(12)
    }
}

#Preview {
    LoadStateItem()
}
