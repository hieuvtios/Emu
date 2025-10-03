//
//  GameEmulatorApp.swift
//  GameEmulator
//
//  Created by Đỗ Việt on 21/9/25.
//

import SwiftUI

@main
struct GameEmulatorApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
