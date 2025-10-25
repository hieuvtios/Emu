//
//  ContentView.swift
//  GameEmulator
//
//  Created by Đỗ Việt on 21/9/25.
//

import SwiftUI
import DeltaCore

struct ContentView: View {

    let game: Game

    init(game: Game? = nil) {
        self.game = game ?? Game()
    }

    var body: some View {
            GameViewControllerRepresentable(game: game)
                .ignoresSafeArea() // Full screen experience
    }
}

// MARK: - GameViewControllerRepresentable
struct GameViewControllerRepresentable: UIViewControllerRepresentable {
    let game: GameProtocol?
    
    init(game: GameProtocol?) {
        self.game = game
    }
    
    func makeUIViewController(context: Context) -> GameViewController {
        let gameViewController = GameViewController()
        gameViewController.game = game
        
        // Set up coordinator as delegate if needed
        context.coordinator.gameViewController = gameViewController
        
        return gameViewController
    }
    
    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        // Update game if it changes
        if uiViewController.game?.fileURL != game?.fileURL {
            uiViewController.game = game
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject {
        weak var gameViewController: GameViewController?
        
        override init() {
            super.init()
            setupNotificationObservers()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        private func setupNotificationObservers() {
            
        }
    }
}
