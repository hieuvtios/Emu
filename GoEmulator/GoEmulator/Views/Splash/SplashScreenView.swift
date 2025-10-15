//
//  SplashScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI
import GoogleMobileAds

struct SplashScreenView: View {
    
    @State private var progress = 0.0
    @State private var showOnboardingScreen = false
    @State private var showTabScreen = false
    @State private var showIAPScreen = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("splash_bg").resizable().ignoresSafeArea()
            
            ProcessBar(progress: $progress)
                .padding(.horizontal, 20)
                .padding(.bottom, 65)
        }
        .background(
            navigationLink()
        )
        .onAppear {
            progress = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                ATTAuthorization.requestIfNeeded(onCompleteATTTracking: {
                    if UserDefaultsManager.shared.isFirstTimeOpen {
                        self.showOnboardingScreen = true
                    } else {
                        if UserDefaultsManager.shared.isPurchased {
                            self.showTabScreen = true
                        } else {
                            self.showIAPScreen = true
                        }
                    }
                })
            }
        }
    }
    
    @ViewBuilder
    func navigationLink() -> some View {
        ZStack {
            navOnboarding()
            
            navTabView()
            
            navPayWallView()
        }

    }
    
    @ViewBuilder
    func navOnboarding() -> some View {
        NavigationLink(isActive: $showOnboardingScreen) {
            OnboardingScreenView()
                .navigationTitle("")
                .navigationBarHidden(true)
        } label: {
            EmptyView()
        }
    }
    
    @ViewBuilder
    func navTabView() -> some View {
        NavigationLink(isActive: $showTabScreen) {
            TabScreenView()
                .navigationTitle("")
                .navigationBarHidden(true)
        } label: {
            EmptyView()
        }
    }
    
    @ViewBuilder
    func navPayWallView() -> some View {
        NavigationLink(isActive: $showIAPScreen) {
            PayWallScreenView(isIapAfterOnboarding: true)
                .navigationTitle("")
                .navigationBarHidden(true)
        } label: {
            EmptyView()
        }
    }
}

#Preview {
    SplashScreenView()
}
