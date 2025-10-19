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

struct BannerAdSwiftUIView: View {
    @EnvironmentObject var networkManager: NetworkManager
    
    var adUnitID: String
    var remote: RemoteConfigValueKey
    var placement: String = ""
    var shimmerBGColor: Color = .init(hex: "D1D1D1")
    var height: CGFloat = 60
    var isActivate: Bool = true
    
    @State private var bannerAd: BannerView?
    @State private var isLoadShimmer: Bool = false
    @State private var isAppear: Bool = true
    
    @State private var availableWidth: CGFloat = Constants.screenWidth
    
    private let reloadBannerLimit: TimeInterval = 30
    
    var isShowBanner: Bool {
        bannerAd != nil && !isLoadShimmer
    }
    
    var body: some View {
        ZStack {
            if !UserDefaultsManager.shared.isPurchased {
                if hasBannerAd {
                    GeometryReader { geo in
                        BannerAdView(bannerAd: bannerAd!, width: geo.size.width)
                            .frame(width: geo.size.width, height: height, alignment: .center)
                            .onChange(of: geo.size.width) { availableWidth = $0 }
                    }
                    .frame(height: height, alignment: .bottom)
                } else if isLoadShimmer {
                    Rectangle()
                        .fill(shimmerBGColor)
                        .shimmering(animation: Animation.linear(duration: 0.75).delay(0.25).repeatForever(autoreverses: false), bandSize: 0.5, mode: .mask)
                        .frame(height: height)
                        .allowsHitTesting(false)
                        .opacity(isShowBanner ? 0 : 1)
                } else {
                    EmptyView()
                        .background(Color.red)
                        .size(.zero)
                }
            }
        }
        .onFirstAppear {
            if isActivate {
                showOrLoadAndShow(width: availableWidth, placement: placement)
            }
            
            Task { @MainActor in
                try? await Task.sleep(seconds: 2)
                if bannerAd == nil {
                    isLoadShimmer = false
                }
            }
        }
        .onAppear {
            isAppear = true
        }
        .onDisappear(perform: {
            isAppear = false
        })
        .onReceive(Timer.publish(every: reloadBannerLimit, on: .main, in: .common).autoconnect(), perform: { _ in
            guard isAppear else { return }
            Logger.logWithTime("Reload Banner")
            if isActivate {
                showOrLoadAndShow(width: availableWidth, placement: placement)
            }
        })
    }
}

extension BannerAdSwiftUIView {
    var hasBannerAd: Bool {
        isAvailableShowAd(remote) && bannerAd != nil
    }
    
    private func showOrLoadAndShow(width: CGFloat, placement: String) {
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        bannerAd = BannerView(adSize: adSize)
        bannerAd?.adUnitID = adUnitID
        bannerAd?.load(Request())
    }
    
    func isAvailableShowAd(_ remote: RemoteConfigValueKey) -> Bool {
        return true && !UserDefaultsManager.shared.isPurchased && networkManager.isConnected
    }
}

struct BannerAdView: UIViewRepresentable {
    var bannerAd: BannerView
    let width: CGFloat
    
    func makeUIView(context: Context) -> BannerView {
        bannerAd.delegate = context.coordinator
        bannerAd.rootViewController = UIApplication.shared.firstKeyWindowRootViewController()
        return bannerAd
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
