//
//  AppDelegate.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 14/10/25.
//

import SwiftUI
import GoogleMobileAds
import FirebaseCore
import DeltaCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Khởi tạo SDK, config analytics, đăng ký services...
        print("App did finish launching")
        FirebaseApp.configure()
        RemoteConfigManager.shared.fetchCloudValues()
        configureAudioSession()
        registerCores()
        ExternalGameControllerManager.shared.startMonitoring()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaultsManager.shared.isFirstTimeOpen = false
        print("App did Exit")
    }
}

private extension AppDelegate {
    func configureAudioSession()
    {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

    func registerCores()
    {
        System.allCases.forEach { Delta.register($0.deltaCore) }
    }
}
