//
//  PlayGameScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct PlayGameScreenView: View {
    var body: some View {
        ZStack {
            AppBackGround()
            
            VStack {
                AppTopBar(title: "Play game")
                
                VStack(alignment: .center, spacing: 14) {
                    Rectangle()
                        .frame(width: 186, height: 185)
                        .cornerRadius(8)
                    
                    VStack(spacing: 8) {
                        Text("Legend of Zelda")
                            .font(Font.custom("SVN-Determination Sans", size: 24))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
                        Text("Game Creation: 18 Sep 2025")
                            .font(Font.custom("Chakra Petch", size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                            .frame(maxWidth: .infinity, alignment: .top)
                        
                        Text("Last Played: 18 Sep 2025")
                            .font(Font.custom("Chakra Petch", size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                            .frame(maxWidth: .infinity, alignment: .top)
                        
                        Text("Play Time: 0 min")
                            .font(Font.custom("Chakra Petch", size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                            .frame(maxWidth: .infinity, alignment: .top)
                    }
                }
                .padding(.horizontal, 0)
                .padding(.top, 30)
                .padding(.bottom, 24)
                
                VStack(spacing: 16) {
                    
                    PlayGameToggleButton(icon: "play_rumble", title: "Rumble")
                    
                    PlayGameToggleButton(icon: "play_cheatcode", title: "Cheat code")
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                AppButton(title: "START GAME") {
                    
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    PlayGameScreenView()
}
