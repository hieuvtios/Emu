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
    let networkManager = NetworkManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashScreenView()
                    .navigationTitle("")
                    .navigationBarHidden(true)
            }
            .environmentObject(networkManager)
        }
    }
}
