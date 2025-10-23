//
//  AppDelegate.swift
//  GameEmulator
//
//  Created by Đỗ Việt on 24/9/25.
//

import UIKit
import AVFoundation
import DeltaCore
import GoogleMobileAds
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
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
        configureAppearance()
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

    func configureAppearance()
    {
        self.window?.tintColor = UIColor.purple
    }
}
