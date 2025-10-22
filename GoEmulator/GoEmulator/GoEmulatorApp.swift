//
//  GoEmulatorApp.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 3/10/25.
//

import SwiftUI

@main
struct GoEmulatorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var networkManager = NetworkManager()
    @StateObject var adDisplayManager = AdDisplayManager()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashScreenView()
                    .navigationTitle("")
                    .navigationBarHidden(true)
            }
            .environmentObject(networkManager)
            .environmentObject(adDisplayManager)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("Scene became active")
                Task { @MainActor in
                    if adDisplayManager.shouldShowOpenAd {
                        OpensAdManager.shared.present()
                    }
                    
                    await OpensAdManager.shared.loadAd(place: "")
                }
            case .background:
                print("Scene moved to background")
            case .inactive:
                print("Scene inactive")
            @unknown default:
                break
            }
        }
    }
}
