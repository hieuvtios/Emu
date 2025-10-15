//
// Project: GoogleAdMobExample
//  File: BannerAdView.swift
//  Created by Noah Carpenter
//  🐱 Follow me on YouTube! 🎥
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
//  Dream Big, Code Bigger
    

import SwiftUI
import GoogleMobileAds
import Shimmer

struct BannerAdWithShimmer: View {
    @State private var loadState: AdLoadState = .loading
    
    var body: some View {
        if !UserDefaultsManager.shared.isPurchased {
            GeometryReader { geo in
                let adSize = currentOrientationAnchoredAdaptiveBanner(width: geo.size.width)
                
                BannerAdView(width: geo.size.width)
                    .frame(width: geo.size.width, height: adSize.size.height, alignment: .center)
            }
            .frame(height: 50, alignment: .bottom)
        }
    }
}

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String = "ca-app-pub-3940256099942544/2934735716" // TEST ID
    let width: CGFloat
    
    func makeUIView(context: Context) -> BannerView {
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = adUnitID
        banner.delegate = context.coordinator
        banner.rootViewController = UIApplication.shared.firstKeyWindowRootViewController()
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        let newSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        if !CGSizeEqualToSize(newSize.size, uiView.adSize.size) {
            uiView.adSize = newSize
            uiView.load(Request())
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject, BannerViewDelegate {
        private var parent: BannerAdView

        init(parent: BannerAdView) {
            self.parent = parent
        }

        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("Banner loaded")
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("Banner failed: \(error.localizedDescription)")
        }
    }
}

private extension UIApplication {
    func firstKeyWindowRootViewController() -> UIViewController? {
        connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController
    }
}

private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first(where: { $0.isKeyWindow }) }
}
