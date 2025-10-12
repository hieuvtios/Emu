//
//  AddNewCodeInputField.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct AddNewCodeInputField: View {
    
    let title: String
    
    @State var text = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Body/14px/Regular
            Group {
                Text(title)
                    .font(Font.custom("Chakra Petch", size: 14))
                    .foregroundColor(.white) +
                
                Text("*")
                    .font(Font.custom("Chakra Petch", size: 14))
                    .foregroundColor(.red)
                   
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
           
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    // Body/16px/Regular
                    Text("Typing here")
                      .font(Font.custom("Chakra Petch", size: 16))
                      .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                      .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .font(Font.custom("Chakra Petch", size: 16))
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 0.11, green: 0.29, blue: 0.72))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.75)
                        .stroke(.white.opacity(0.25), lineWidth: 1.5)
                )
            
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

//#Preview {
//    AddNewCodeInputField()
//        .background(.red)
//}
