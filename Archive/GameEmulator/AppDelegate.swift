//
//  AppDelegate.swift
//  GameEmulator
//
//  Created by Đỗ Việt on 24/9/25.
//

import UIKit
import AVFoundation
import DeltaCore

private extension CFNotificationName {
    static let altstoreRequestAppState: CFNotificationName = CFNotificationName("com.altstore.RequestAppState.com.rileytestut.Delta" as CFString)
    static let altstoreAppIsRunning: CFNotificationName = CFNotificationName("com.altstore.AppState.Running.com.rileytestut.Delta" as CFString)
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        configureAudioSession()
        registerCores()
        configureAppearance()

        // Controllers
        ExternalGameControllerManager.shared.startMonitoring()

        return true
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
