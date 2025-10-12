//
//  AddNewCodeBottomSheet.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct AddNewCodeBottomSheet: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.8)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 16) {
                    // Title/24px/Bold
                    Text("Add new code")
                        .font(Font.custom("SVN-Determination Sans", size: 24))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Button {
                        
                    } label: {
                        Image("home_ic_close")
                    }
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 16)
                
                AddNewCodeInputField(title: "Cheat code name")
                
                Spacer().frame(height: 16)
                
                AddNewCodeInputField(title: "Code")
                
                Spacer().frame(height: 32)
                
                Button {
                    
                } label: {
                    Text("SAVE")
                        .font(Font.custom("SVN-Determination Sans", size: 20))
                        .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                        .padding(.leading, 24)
                        .padding(.trailing, 20)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Image("ob_button_4").resizable())
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.05, green: 0.2, blue: 0.53))
            .cornerRadius(16)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AddNewCodeBottomSheet()
}
