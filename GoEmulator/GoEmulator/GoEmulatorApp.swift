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
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashScreenView()
                    .navigationTitle("")
                    .navigationBarHidden(true)
            }
            .environmentObject(networkManager)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("Scene became active")
                Task { @MainActor in
                    // Show ad nếu có sẵn
                    OpensAdManager.shared.present()
                    
                    // Load ad mới cho lần sau
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
