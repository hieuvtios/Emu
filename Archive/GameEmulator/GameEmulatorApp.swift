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

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabScreenView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
