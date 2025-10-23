//
//  ControllerBottomSheet.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct ControllerBottomSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var playerNumber: Int
    @Binding var touchScreenNumber: Int
    
    @State var showTouchScreenOption = false
    let paddingBottom: CGFloat = 205
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    // Title/24px/Bold
                    Text("Controller")
                        .font(Font.custom("SVN-Determination Sans", size: 24))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Button {
                        dismiss()
                    } label: {
                        Image("home_ic_close")
                            .frame(width: 24, height: 24)
                    }
                }
                
                Spacer().frame(height: 16)
                
                numberPlayer()
                
                Spacer().frame(height: 16)
                
                stateOption()
                
                Spacer().frame(height: 40)
                
                AppButton(title: "Save") {
                    
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 64)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.05, green: 0.2, blue: 0.53))
            .cornerRadius(16)
            
            if showTouchScreenOption {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(0..<5) { index in
                        Button {
                            
                        } label: {
                            HStack(alignment: .center, spacing: 16) {
                                // Body/14px/Regular
                                Text("Touch Screen")
                                    .font(Font.custom("Chakra Petch", size: 14))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                
                                Image(touchScreenNumber == index ? "Radio" : "Radio 1")
                            }
                            .padding(0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.06, green: 0.22, blue: 0.58))
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .shadow(color: .black.opacity(0.25), radius: 6.45, x: 0, y: -6)
                .padding(.horizontal, 20)
                .padding(.bottom, paddingBottom)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func numberPlayer() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title/18px/Medium
            Text("Number Player")
                .font(
                    Font.custom("Chakra Petch", size: 18)
                        .weight(.medium)
                )
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
            LazyVGrid(columns: columns) {
                ForEach(1..<5) { index in
                    Button {
                        
                    } label: {
                        // Body/14px/Medium
                        Text("Player \(index)")
                            .font(
                                Font.custom("Chakra Petch", size: 14)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(red: 0.07, green: 0.24, blue: 0.63).opacity(0.5))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.94, green: 0.69, blue: 0.98), lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    func stateOption() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sate")
                .font(
                    Font.custom("Inter", size: 14)
                        .weight(.medium)
                )
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            HStack(alignment: .center, spacing: 16) {
                Text("Touch Screen")
                    .font(
                        Font.custom("Inter", size: 14)
                            .weight(.medium)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Image(showTouchScreenOption ? "Angle Left" : "Angle Left 1")
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.07, green: 0.24, blue: 0.63).opacity(0.5))
            .cornerRadius(12)
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .onTapGesture {
            showTouchScreenOption.toggle()
        }
    }
}

#Preview {
    TabScreenView()
}
