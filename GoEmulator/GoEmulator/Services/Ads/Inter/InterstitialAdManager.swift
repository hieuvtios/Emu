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
    private let limitDurationAllInter: TimeInterval = 40
    private var lastDateInterDismiss: Date?
    
    func setInterDismiss() {
        lastDateInterDismiss = Date()
    }
    
    func getInterLimited() -> Bool {
        guard let lastDate = lastDateInterDismiss else { return false }
        let time = Date().timeIntervalSince(lastDate)
        return time <= limitDurationAllInter
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
        return limitManager.getInterLimited()
    }
    
    func remoteConfigIsActive() -> Bool {
        return true/*RemoteConfigHelper.shared.bool(key: remoteKey) /// - Remote config show ad or not*/
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
