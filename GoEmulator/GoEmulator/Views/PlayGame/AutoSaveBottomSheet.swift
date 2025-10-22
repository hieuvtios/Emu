//
//  AutoSaveBottomSheet.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct AutoSaveBottomSheet: View {
    var onDismissAction: () -> ()
    var onAutoSaveAction: () -> ()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.8)
            
            VStack(alignment: .center, spacing: 0) {
                Spacer().frame(height: 56)
                
                VStack(alignment: .center, spacing: 4) {
                    // Title/24px/Bold
                    Text("Autosave is off")
                        .font(Font.custom("SVN-Determination Sans", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Body/16px/Light
                    Text("Enable it in the Game Menu to avoid losing progress. Skip if you’ve already saved.")
                        .font(
                            Font.custom("Chakra Petch", size: 16)
                                .weight(.light)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                        .frame(maxWidth: .infinity, alignment: .top)
                    
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
                                        Text("DISMISS")
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
                                        Text("ON AUTOSAVE")
                                            .font(Font.custom("SVN-Determination Sans", size: 20))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color(red: 0.54, green: 0.09, blue: 0.61))
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 48)
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .padding(.horizontal, 0)
            .padding(.top, 24)
            .padding(.bottom, 64)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.05, green: 0.2, blue: 0.53))
            .cornerRadius(16, corners: [.topLeft, .topRight])
            .overlay(alignment: .top) {
                Image("autosave_icon")
                    .offset(y: -60)
            }
        }
        .ignoresSafeArea()
    }
}
