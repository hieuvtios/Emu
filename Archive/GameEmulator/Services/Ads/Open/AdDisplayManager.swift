//
//  AdDisplayManager.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 21/10/25.
//

import SwiftUI

class AdDisplayManager: ObservableObject {
    @Published var shouldShowOpenAd = true
    
    // Danh sách các view không muốn hiển thị ads
    private var blockedScreens: Set<String> = []
    
    func blockAdsForScreen(_ screenName: String) {
        blockedScreens.insert(screenName)
        shouldShowOpenAd = false
    }
    
    func allowAdsForScreen(_ screenName: String) {
        blockedScreens.remove(screenName)
        // Chỉ cho phép ads nếu không còn screen nào block
        shouldShowOpenAd = blockedScreens.isEmpty
    }
    
    func allowAds() {
        shouldShowOpenAd = true
    }
    
    func blockAds() {
        shouldShowOpenAd = false
    }
}

struct BlockAdsModifier: ViewModifier {
    @EnvironmentObject var adManager: AdDisplayManager
    let screenName: String
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                adManager.blockAdsForScreen(screenName)
            }
            .onDisappear {
                adManager.allowAdsForScreen(screenName)
            }
    }
}

extension View {
    func blockOpenAds(screenName: String = "") -> some View {
        self.modifier(BlockAdsModifier(screenName: screenName))
    }
}
