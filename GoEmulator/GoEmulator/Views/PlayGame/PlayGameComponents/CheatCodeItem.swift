//
//  CheatCodeItem.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct CheatCodeItem: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                // Body/16px/Bold
                Text("Cheat code 1")
                    .font(
                        Font.custom("Chakra Petch", size: 16)
                            .weight(.bold)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                // Caption/12px/Regular
                Text("AHSNCJ")
                    .font(Font.custom("Chakra Petch", size: 12))
                    .foregroundColor(Color(red: 0.65, green: 0.8, blue: 1))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                HStack(alignment: .top, spacing: 12) {
                    // Caption/12px/Medium
                    Button {
                        
                    } label: {
                        Text("Edit Code")
                          .font(
                            Font.custom("Chakra Petch", size: 12)
                              .weight(.medium)
                          )
                          .underline()
                          .foregroundColor(Color(red: 0.94, green: 0.69, blue: 0.98))
                    }
                    
                    Button {
                        
                    } label: {
                        // Caption/12px/Medium
                        Text("Delete")
                          .font(
                            Font.custom("Chakra Petch", size: 12)
                              .weight(.medium)
                          )
                          .underline()
                          .foregroundColor(Color(red: 0.94, green: 0.27, blue: 0.27))
                    }
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image("Radio 1")
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.07, green: 0.24, blue: 0.63).opacity(0.5))
        .cornerRadius(12)
    }
}

#Preview {
    CheatCodeItem()
}
