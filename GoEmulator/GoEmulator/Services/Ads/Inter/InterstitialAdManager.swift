//
    // Project: GoogleAdMobExample
    //  File: InterstitialAdManager.swift
    //  Created by Noah Carpenter
    //  🐱 Follow me on YouTube! 🎥
    //  https://www.youtube.com/@NoahDoesCoding97
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
    //  Dream Big, Code Bigger
    


import SwiftUI
import GoogleMobileAds
import Combine
import Foundation

fileprivate class InterLimitManager {
    static let shared = InterLimitManager()
    
    // Giới hạn thời gian giữa các lần dismiss inter ads
    private var limitDurationAllInter: TimeInterval = 40
    private var lastDateInterDismiss: Date?
    
    // Giới hạn số lần show inter ads trong một khoảng thời gian
    private var timeShowInterAds: TimeInterval = 120 // Thời gian cửa sổ (giây)
    private var numberShowInterAds: Int = 5 // Số lần show tối đa
    private var interShowHistory: [Date] = [] // Lưu lịch sử show inter ads
    
    func setlimitDurationAllInter() {
        limitDurationAllInter = RemoteConfigManager.shared.timeInterval(forKey: .time_between_inter_ads)
        print("Inter Duration \(limitDurationAllInter)")
    }
    
    func setTimeShowInterAds() {
        timeShowInterAds = RemoteConfigManager.shared.timeInterval(forKey: .time_show_inter_ads)
        print("Time Show Inter Ads Window: \(timeShowInterAds)s")
    }
    
    func setNumberShowInterAds() {
        numberShowInterAds = RemoteConfigManager.shared.int(forKey: .number_show_inter_ads)
        print("Max Number Show Inter Ads: \(numberShowInterAds)")
    }
    
    func setInterDismiss() {
        lastDateInterDismiss = Date()
    }
    
    func recordInterShow() {
        let now = Date()
        interShowHistory.append(now)
        
        // Xóa các record cũ nằm ngoài cửa sổ thời gian
        cleanupOldHistory(currentTime: now)
    }
    
    private func cleanupOldHistory(currentTime: Date) {
        let cutoffTime = currentTime.addingTimeInterval(-timeShowInterAds)
        interShowHistory = interShowHistory.filter { $0 > cutoffTime }
    }
    
    // Kiểm tra giới hạn dựa trên thời gian giữa các lần dismiss
    func getInterLimited() -> Bool {
        guard let lastDate = lastDateInterDismiss else { return false }
        let time = Date().timeIntervalSince(lastDate)
        return time <= limitDurationAllInter
    }
    
    // Kiểm tra giới hạn dựa trên số lần show trong khoảng thời gian
    func isInterShowLimitReached() -> Bool {
        let now = Date()
        cleanupOldHistory(currentTime: now)
        
        // Kiểm tra xem đã đạt giới hạn số lần show chưa
        let showCountInWindow = interShowHistory.count
        let isLimitReached = showCountInWindow >= numberShowInterAds
        
        if isLimitReached {
            print("Inter ads limit reached: \(showCountInWindow)/\(numberShowInterAds) in last \(timeShowInterAds)s")
        }
        
        return isLimitReached
    }
    
    // Hàm tổng hợp để kiểm tra xem có thể show inter ads không
    func canShowInterAds() -> Bool {
        // Kiểm tra cả 2 điều kiện:
        // 1. Thời gian từ lần dismiss cuối
        // 2. Số lần show trong khoảng thời gian
        let isTimeLimited = getInterLimited()
        let isShowLimitReached = isInterShowLimitReached()
        
        let canShow = !isTimeLimited && !isShowLimitReached
        
        if !canShow {
            if isTimeLimited {
                print("Cannot show inter: Time limit not passed")
            }
            if isShowLimitReached {
                print("Cannot show inter: Show count limit reached")
            }
        }
        
        return canShow
    }
    
    // Hàm để reset tất cả các giới hạn (nếu cần)
    func resetLimits() {
        lastDateInterDismiss = nil
        interShowHistory.removeAll()
        print("Inter ads limits reset")
    }
    
    // Hàm để lấy thông tin debug
    func getDebugInfo() -> String {
        let now = Date()
        cleanupOldHistory(currentTime: now)
        
        var info = "=== Inter Ads Debug Info ===\n"
        info += "Time between ads: \(limitDurationAllInter)s\n"
        info += "Show window: \(timeShowInterAds)s\n"
        info += "Max shows in window: \(numberShowInterAds)\n"
        info += "Current shows in window: \(interShowHistory.count)\n"
        
        if let lastDismiss = lastDateInterDismiss {
            let timeSinceLastDismiss = now.timeIntervalSince(lastDismiss)
            info += "Time since last dismiss: \(Int(timeSinceLastDismiss))s\n"
        } else {
            info += "No previous dismiss recorded\n"
        }
        
        info += "Can show ads: \(canShowInterAds())\n"
        info += "=========================="
        
        return info
    }
}

class InterstitialAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    var adUnitID: String
    var remote: RemoteConfigValueKey
    var placement: String
    
    @Published var interstitial: InterstitialAd?
    @Published var isLoadingAd = false
    private var limitManager: InterLimitManager?
    
    init(adUnitID: String, remote: RemoteConfigValueKey, placement: String = "") {
        self.adUnitID = adUnitID
        self.remote = remote
        self.placement = placement
        self.limitManager = .shared
        self.limitManager?.setlimitDurationAllInter()
        self.limitManager?.setTimeShowInterAds()
        self.limitManager?.setNumberShowInterAds()
    }

    func loadAd(completion: @escaping ((Result<InterstitialAd?, Error>)->Void)) {
        isLoadingAd = true
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error {
                print("Interstitial failed to load: \(error)")
                completion(.failure(error))
                return
            }
        
            print("Interstitial loaded")
            self?.interstitial = ad
            completion(.success(ad))
        }
    }

    func present() {
        guard let root = UIApplication.shared.firstKeyWindowRootViewController() else {
            return
        }
        guard let interstitial else {
            print("Interstitial not ready — loading now")
            return
        }
        isLoadingAd = false
        interstitial.fullScreenContentDelegate = self
        interstitial.present(from: root)
        limitManager?.recordInterShow()
    }
    
    func loadAndShow(placement: String = "", completion: ((AdsResult) -> Void)? = nil) {
        /// check can load ad or show
        guard isAdCanLoading() else {
            completion?(.fail)
            return
        }
        
        loadAd { result in
            switch result {
            case .success(_):
                completion?(.succes)
                self.present()
            case .failure(_):
                completion?(.fail)
                self.isLoadingAd = false
            }
        }
    }

    // MARK: - GADFullScreenContentDelegate
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Interstitial dismissed — loading next")
        self.interstitial = nil
        self.limitManager?.setInterDismiss()
        print(limitManager?.getDebugInfo())
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial failed to present: \(error)")
        self.interstitial = nil
    }
}

extension InterstitialAdManager {
    func isAdAvailable() -> Bool {
        return interstitial != nil
    }
    
    func isAdCanLoading() -> Bool {
        return !isInterLimited() && remoteConfigIsActive() && !getIsAppPurchase()
    }
    
    private func isInterLimited() -> Bool {
        guard let limitManager else { return false }
        return !limitManager.canShowInterAds()
    }
    
    func remoteConfigIsActive() -> Bool {
        return RemoteConfigManager.shared.bool(forKey: remote)
    }
    
    func getIsAppPurchase() -> Bool {
        UserDefaultsManager.shared.isPurchased
    }
}

// Helper to locate a root view controller for presentation in multi-scene apps.
private extension UIApplication {
    func firstKeyWindowRootViewController() -> UIViewController? {
        connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow } // Iterate active scenes and find the key window
            .first?
            .rootViewController
    }
}

// Convenience to fetch the key window for a scene
private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first(where: { $0.isKeyWindow }) }
}
