//
//  OpensManager.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 18/10/25.
//

import SwiftUI
import GoogleMobileAds
import Combine
import Foundation

// MARK: - App Open Limit Manager
fileprivate final class AppOpenLimitManager {
    static let shared = AppOpenLimitManager()
    
    private let limitDurationAppOpen: TimeInterval = 2 * 60 * 60 // 2 hours
    private var lastAppOpenDismissDate: Date?
    
    private init() {}
    
    func setAppOpenDismiss() {
        lastAppOpenDismissDate = Date()
    }
    
    /// Kiểm tra xem đã đủ thời gian để show ad mới chưa
    func canShowAppOpen() -> Bool {
        guard let lastDate = lastAppOpenDismissDate else {
            return true // Chưa show lần nào -> cho phép show
        }
        let timeElapsed = Date().timeIntervalSince(lastDate)
        return timeElapsed >= limitDurationAppOpen
    }
}

// MARK: - Opens Ad Manager
@MainActor
final class OpensAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    
    static let shared = OpensAdManager()
    
    // MARK: - Properties
    private let adUnitID: String = GoogleAdMobUnitId.appOpen
    private let remote: RemoteConfigValueKey = .is_show_ads_open
    private var placement: String = ""
    
    @Published private(set) var appOpenAd: AppOpenAd?
    @Published private(set) var isLoadingAd = false
    @Published private(set) var isShowingAd = false
    
    private let limitManager = AppOpenLimitManager.shared
    
    // MARK: - Initialization
    private override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    @discardableResult
    func loadAd(place: String) async -> Bool {
        // Validate before loading
        guard isAdAvailable() else {
            print("⚠️ App open ad not available - skipping load")
            appOpenAd = nil
            return false
        }
        
        // Prevent concurrent loads
        guard !isLoadingAd else {
            print("⚠️ Already loading an ad")
            return false
        }
        
        // Store placement for potential retry
        placement = place
        isLoadingAd = true
        
        defer { isLoadingAd = false }
        
        do {
            let request = Request()
            appOpenAd = try await AppOpenAd.load(with: adUnitID, request: request)
            appOpenAd?.fullScreenContentDelegate = self
            print("✅ App open ad loaded successfully for placement: \(place)")
            return true
        } catch {
            print("❌ App open ad failed to load: \(error.localizedDescription)")
            appOpenAd = nil
            return false
        }
    }
    
    func present() {
        // Validate ad availability
        guard isAdAvailable() else {
            print("⚠️ App open ad not available for presentation")
            return
        }
        
        // Check if ad is loaded
        guard let appOpenAd = appOpenAd else {
            print("⚠️ No app open ad loaded")
            return
        }
        
        // Prevent showing ad if already showing
        guard !isShowingAd else {
            print("⚠️ Ad is already being shown")
            return
        }
        
        // Get root view controller
        guard let rootVC = UIApplication.shared.firstKeyWindowRootViewController() else {
            print("⚠️ No root view controller found")
            return
        }
        
        print("📱 Presenting app open ad")
        appOpenAd.present(from: rootVC)
        isShowingAd = true
    }
    
    // MARK: - Availability Check
    func isAdAvailable() -> Bool {
        let canShow = limitManager.canShowAppOpen()
        let remoteEnabled = remoteConfigIsActive()
        let notPurchased = !getIsAppPurchase()
        
#if DEBUG
        print("""
        🔍 Ad Availability Check:
           - Can show (time limit): \(canShow)
           - Remote enabled: \(remoteEnabled)
           - Not purchased: \(notPurchased)
           - Result: \(canShow && remoteEnabled && notPurchased)
        """)
#endif
        
        return canShow && remoteEnabled && notPurchased
    }
    
    // MARK: - Private Helpers
    private func remoteConfigIsActive() -> Bool {
        // TODO: Implement remote config check
        return true
        // return RemoteConfigHelper.shared.bool(key: remote)
    }
    
    private func getIsAppPurchase() -> Bool {
        return UserDefaultsManager.shared.isPurchased
    }
}

// MARK: - FullScreenContentDelegate
extension OpensAdManager {
    
    nonisolated func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("📊 App open ad recorded an impression")
    }
    
    nonisolated func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("👆 App open ad recorded a click")
    }
    
    nonisolated func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("🎬 App open ad will be presented")
    }
    
    nonisolated func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("🔚 App open ad will be dismissed")
    }
    
    nonisolated func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("✅ App open ad was dismissed")
        Task { @MainActor in
            appOpenAd = nil
            isShowingAd = false
            limitManager.setAppOpenDismiss()
        }
    }
    
    nonisolated func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("❌ App open ad failed to present: \(error.localizedDescription)")
        Task { @MainActor in
            appOpenAd = nil
            isShowingAd = false
            
            // Retry after delay
            try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
            await loadAd(place: placement)
        }
    }
}

// MARK: - UIApplication Extension
private extension UIApplication {
    func firstKeyWindowRootViewController() -> UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .compactMap { $0.keyWindow }
            .first?
            .rootViewController
    }
}

// MARK: - UIWindowScene Extension
private extension UIWindowScene {
    var keyWindow: UIWindow? {
        windows.first(where: \.isKeyWindow)
    }
}
