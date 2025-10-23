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
    @StateObject var networkManager = NetworkManager()
    @StateObject var adDisplayManager = AdDisplayManager()
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var tabViewModel = TabViewModel()

    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
//            DirectoryAlert()
            NavigationView {
                TabScreenView()
                    .navigationTitle("")
                    .navigationBarHidden(true)
            }
          
            .environmentObject(networkManager)
            .environmentObject(adDisplayManager)
            .environmentObject(tabViewModel)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .fullScreenCover(isPresented: $tabViewModel.showGameView) {
                if let game = tabViewModel.selectedGame {
                    ContentView(game: game)
                }
            }
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
//    var body: some Scene {
//        WindowGroup {
//            TabScreenView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
}
