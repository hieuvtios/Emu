//
//  GameMenuScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct GameMenuScreenView: View {
    var body: some View {
        ZStack {
            AppBackGround()
            
            VStack {
                AppTopBar(title: "Game menu")
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        MenuButton(gameMenu: .autoSave, buttonType: .type1) {
                            
                        }
                        
                        MenuButton(gameMenu: .loadState, buttonType: .type1) {
                            
                        }
                        
                        MenuButton(gameMenu: .restart, buttonType: .type1) {
                            
                        }
                        
                        MenuButton(gameMenu: .cheatCode, buttonType: .type2) {
                            
                        }
                        
                        MenuButton(gameMenu: .mute, buttonType: .type3) {
                            
                        }
                        
                        MenuButton(gameMenu: .rumble, buttonType: .type3) {
                            
                        }
                        
                        MenuButton(gameMenu: .fastForward, buttonType: .type3) {
                            
                        }
                        
                        MenuButton(gameMenu: .autoSave, buttonType: .type3) {
                            
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
        }
    }
}

#Preview {
    GameMenuScreenView()
}
