//
//  Setting.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 11/10/25.
//

import SwiftUI

struct SettingScreenView: View {
    
    @StateObject var settingViewModel = SettingViewModel()
    
    var body: some View {
        VStack {
            SettingTopTitle()
            
            if !UserDefaultsManager.shared.isPurchased {
                SettingPremiumBanner(onTapAction: {
                    settingViewModel.showIAPView = true
                })
                .padding(.horizontal, 20)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    
                    SettingItem(item: .directory) {
                        
                    }
                    
                    SettingItem(item: .airPlayscreen) {
                        settingViewModel.showAirplayGuide = true
                    }
                    
                    SettingItem(item: .fullScreen) {
                        settingViewModel.showFullScreenOption = true
                    }
                    
                    SettingItem(item: .controller) {
                        settingViewModel.showControllerOption = true
                    }
                    .addSpotlight(3, text: "")
                    
                    SettingItem(item: .manageSub) {
                        
                    }
                    
                    SettingItem(item: .term) {
                        
                    }
                    
                    SettingItem(item: .privacy) {
                        
                    }
                    
                    SettingItem(item: .review) {
                        settingViewModel.showReview = true
                    }
                    
                    Spacer().frame(height: 100)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(
            navAiPlayGuide()
        )
        .fullScreenCover(isPresented: $settingViewModel.showIAPView) {
            PayWallScreenView()
        }
        .fullScreenCover(isPresented: $settingViewModel.showFullScreenOption) {
            PlayFullScreenBottomSheet(fullScreenOption: $settingViewModel.fullScreenOption)
                .background(ClearBackgroundView())
        }
        .fullScreenCover(isPresented: $settingViewModel.showControllerOption) {
            ControllerBottomSheet(playerNumber: $settingViewModel.playerNumber, touchScreenNumber: $settingViewModel.touchScreenNumber)
                .background(ClearBackgroundView())
        }
        .fullScreenCover(isPresented: $settingViewModel.showReview) {
            RatingScreenView()
                .background(ClearBackgroundView())
        }
    }
}

extension SettingScreenView {
    @ViewBuilder
    func navAiPlayGuide() -> some View {
        NavigationLink(isActive: $settingViewModel.showAirplayGuide) {
            AirPlayGuideScreenView()
                .navigationTitle("")
                .navigationBarHidden(true)
        } label: {
            EmptyView()
        }
    }
}

#Preview {
    TabScreenView()
}
