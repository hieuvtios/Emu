//
//  AirPlayGuideScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct AirPlayGuideScreenView: View {
    
    @State private var toggleWifi = true
    
    var body: some View {
        ZStack {
            AppBackGround()
            
            VStack {
                AppTopBar(title: "Air Play")
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 16) {
                        Image("image 2020")
                            .resizable()
                            .scaledToFit()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .center, spacing: 8) {
                                Text("1")
                                    .font(
                                        Font.custom("Chakra Petch", size: 20)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(Color(red: 0.54, green: 0.09, blue: 0.61))
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(Color(red: 0.94, green: 0.69, blue: 0.98))
                                    )
                                
                                VStack(spacing: 0) {
                                    Group {
                                        Text("Connect WiFi ")
                                            .font(
                                                Font.custom("Chakra Petch", size: 14)
                                                    .weight(.bold)
                                            )
                                            .foregroundColor(Color(red: 0.94, green: 0.69, blue: 0.98)) +
                                        
                                        Text(" both devices ")
                                            .font(
                                                Font.custom("Chakra Petch", size: 14)
                                                    .weight(.bold)
                                            )
                                            .foregroundColor(Color.white)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                   
                                    // Caption/12px/Regular
                                    Text("Connect to the same wifi on your both devices")
                                        .font(Font.custom("Chakra Petch", size: 12))
                                        .foregroundColor(Color(red: 0.65, green: 0.8, blue: 1))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                            }
                            .padding(0)
                            
                            VStack(spacing: 16) {
                                HStack(alignment: .center, spacing: 16) {
                                    Image("Frame 2217")
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        // Caption/Body/16px/Bold
                                        Text("Your Wifi ")
                                            .font(
                                                Font.custom("Inter", size: 16)
                                                    .weight(.bold)
                                            )
                                            .foregroundColor(.white)
                                        
                                        HStack(alignment: .center, spacing: 2) {
                                            Circle()
                                                .fill(Color(red: 0.13, green: 0.77, blue: 0.37))
                                                .frame(width: 4, height: 4)
                                            
                                            // Caption/8px/Regular
                                            Text("Connected")
                                                .font(Font.custom("Chakra Petch", size: 8))
                                                .foregroundColor(Color(red: 0.49, green: 0.67, blue: 1))
                                        }
                                        .padding(0)
                                    }
                                    
                                    Toggle("", isOn: $toggleWifi)
                                        .tint(Color(red: 0.94, green: 0.69, blue: 0.98))
                                }
                                
                                Image("Frame 2221")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 0)
                            .frame(maxWidth: .infinity)
                        }
                        
                        HStack(alignment: .center, spacing: 0) {
                            Text("2")
                                .font(
                                    Font.custom("Chakra Petch", size: 20)
                                        .weight(.bold)
                                )
                                .foregroundColor(Color(red: 0.54, green: 0.09, blue: 0.61))
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color(red: 0.94, green: 0.69, blue: 0.98))
                                )
                            
                            Spacer().frame(width: 8)
                            
                            VStack(spacing: 0) {
                                Text("Tap Screen Mirroring to start")
                                    .font(
                                        Font.custom("Chakra Petch", size: 14)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(Color(red: 0.94, green: 0.69, blue: 0.98))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                
                                // Caption/12px/Regular
                                Text("Screen Mirroring in Control Center")
                                    .font(Font.custom("Chakra Petch", size: 12))
                                    .foregroundColor(Color(red: 0.65, green: 0.8, blue: 1))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            
                            Spacer().frame(width: 12)
                            
                            Image("image 2022")
                        }
                      
                        HStack(alignment: .center, spacing: 0) {
                            Text("3")
                                .font(
                                    Font.custom("Chakra Petch", size: 20)
                                        .weight(.bold)
                                )
                                .foregroundColor(Color(red: 0.54, green: 0.09, blue: 0.61))
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color(red: 0.94, green: 0.69, blue: 0.98))
                                )
                            
                            Spacer().frame(width: 8)
                            
                            VStack(spacing: 0) {
                                Text("Select a device to connectt")
                                    .font(
                                        Font.custom("Chakra Petch", size: 14)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(Color(red: 0.94, green: 0.69, blue: 0.98))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                
                                // Caption/12px/Regular
                                Text("Select the appropriate device and proceed to connect.")
                                    .font(Font.custom("Chakra Petch", size: 12))
                                    .foregroundColor(Color(red: 0.65, green: 0.8, blue: 1))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            
                            Spacer().frame(width: 12)
                            
                            Image("image 2021")
                        }
                        
                        HStack(alignment: .center, spacing: 0) {
                            Text("4")
                                .font(
                                    Font.custom("Chakra Petch", size: 20)
                                        .weight(.bold)
                                )
                                .foregroundColor(Color(red: 0.54, green: 0.09, blue: 0.61))
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color(red: 0.94, green: 0.69, blue: 0.98))
                                )
                            
                            Spacer().frame(width: 8)
                            
                            VStack(spacing: 0) {
                                Text("Enter passcode to connect")
                                    .font(
                                        Font.custom("Chakra Petch", size: 14)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(Color(red: 0.94, green: 0.69, blue: 0.98))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                
                                // Caption/12px/Regular
                                Text("If an AirPlay passcode appears on your TV screen or Mac, enter the passcode on your iPhone or iPad.")
                                    .font(Font.custom("Chakra Petch", size: 12))
                                    .foregroundColor(Color(red: 0.65, green: 0.8, blue: 1))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                        }
                        
                        HStack(spacing: 8) {
                            ForEach(0..<4) { _ in
                                Image("home_ic_close")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .frame(width: 31, height: 45)
                                    .background(Color(red: 0.05, green: 0.2, blue: 0.53))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                
                AppButton(title: "START NOW") {
                    
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    AirPlayGuideScreenView()
}
