//
//  DirectoryAlert.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 22/10/25.
//

import SwiftUI

struct DirectoryAlert: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                VStack(spacing: 4) {
                    // Title/24px/Bold
                    Text("Directory")
                        .font(Font.custom("Chakra Petch", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Make Quick Scan easier—do you \nwant to set your default folder?")
                        .font(
                            Font.custom("Chakra Petch", size: 16)
                                .weight(.light)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                        .frame(maxWidth: .infinity, alignment: .top)
                }
                
                Spacer().frame(height: 24)
                
                GeometryReader { geo in
                    HStack(spacing: 12) {
                        let width = geo.size.width - 12
                        let grayButtonWidth = width / 3
                        let pinkButtonWidth = width * 2 / 3
                        
                        Button {
                            
                        } label: {
                            Image("ob_button_2")
                                .resizable()
                                .frame(width: grayButtonWidth, height: 48)
                                .overlay {
                                    Text("LATER")
                                        .font(Font.custom("SVN-Determination Sans", size: 20))
                                        .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                                }
                        }
                        
                        Button {
                            
                        } label: {
                            Image("ob_button_3")
                                .resizable()
                                .frame(width: pinkButtonWidth, height: 48)
                                .overlay {
                                    Text("CHOOSE FOLDER")
                                        .font(Font.custom("SVN-Determination Sans", size: 20))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.54, green: 0.09, blue: 0.61))
                                }
                        }
                    }
                }
                .frame(height: 48)
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 32)
            .background(
                Color(red: 0.05, green: 0.2, blue: 0.53)
            )
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    DirectoryAlert()
}
