//
//  AppDelegate.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 14/10/25.
//

import SwiftUI
import GoogleMobileAds
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Khởi tạo SDK, config analytics, đăng ký services...
        print("App did finish launching")
        FirebaseApp.configure()
        RemoteConfigManager.shared.fetchCloudValues()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaultsManager.shared.isFirstTimeOpen = false
        print("App did Exit")
    }
}
