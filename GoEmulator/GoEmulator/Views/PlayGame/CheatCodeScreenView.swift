//
//  CheatCodeScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct CheatCodeScreenView: View {
    var body: some View {
        ZStack {
            AppBackGround()
            
            VStack {
                CheatCodeTopBar(title: "Cheat Code", onTapInfoAction: {
                    
                })
                
                HStack(alignment: .center, spacing: 16) {
                    Button {
                        
                    } label: {
                        HStack(alignment: .center, spacing: 10) {
                            Image("plus")
                            
                            // Body/14px/Semibold
                            Text("New code")
                                .font(
                                    Font.custom("Chakra Petch", size: 14)
                                        .weight(.semibold)
                                )
                                .foregroundColor(Color(red: 0.54, green: 0.09, blue: 0.61))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.94, green: 0.69, blue: 0.98))
                        .cornerRadius(100)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.44, green: 0.59, blue: 0.95), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(0..<10) { _ in
                            CheatCodeItem()
                        }
                    }
                    
                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 20)
                
                Button {
                    
                } label: {
                    Text("APPLY CHEAT CODE")
                        .font(Font.custom("SVN-Determination Sans", size: 20))
                        .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                        .padding(.leading, 24)
                        .padding(.trailing, 20)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Image("ob_button_4").resizable())
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    CheatCodeScreenView()
}
