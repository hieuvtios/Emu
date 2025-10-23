//
//  TabViewModel.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 4/10/25.
//

import SwiftUI
import DeltaCore

class TabViewModel: ObservableObject {
    @Published var tabSelection: AppScreen = .home

    @Published var isExpanded: Bool = false

    @Published var showDocumentPicker = false
    @Published var showGameView = false
    @Published var selectedGame: Game?
    @Published var currentSpot: Int? = -1
    @Published var showGuideView = false

    @Published var importSuccessMessage: String?
    @Published var importErrorMessage: String?

    private let gameManager = GameManager.shared

    /// Handle imported game files from DocumentPicker
    func handleImportedGames(_ urls: [URL]) {
        print("🎮 TabViewModel handling \(urls.count) imported game(s)")

        guard let firstURL = urls.first else {
            print("❌ No URLs provided")
            importErrorMessage = "No game file selected"
            return
        }

        print("📍 Game file URL: \(firstURL.path)")
        print("📂 File exists: \(FileManager.default.fileExists(atPath: firstURL.path))")

        // Detect game type from file extension
        let fileExtension = firstURL.pathExtension
        print("📝 File extension: \(fileExtension)")

        guard let gameType = GameType(fileExtension: fileExtension) else {
            print("❌ Unsupported game file type: \(fileExtension)")
            importErrorMessage = "Unsupported file type: .\(fileExtension)"
            return
        }

        print("🎯 Detected game type: \(gameType)")

        // Import game using GameManager
        if let gameEntity = gameManager.importGame(from: firstURL, gameType: gameType) {
            print("✅ Game imported successfully: \(gameEntity.name)")
            importSuccessMessage = "'\(gameEntity.name)' added to your library!"

            // Notify HomeViewModel to refresh the list
            NotificationCenter.default.post(name: .gameLibraryUpdated, object: nil)

            // Optionally launch the game immediately
            // if let game = gameEntity.toGame() {
            //     selectedGame = game
            //     showGameView = true
            // }
        } else {
            print("❌ Failed to import game")
            importErrorMessage = "Failed to import game. Please try again."
        }
    }

    /// Launch a game for playing
    func launchGame(_ gameEntity: GameEntity) {
        guard let game = gameEntity.toGame() else {
            importErrorMessage = "Cannot load game file"
            return
        }

        // Update last played
        gameManager.updateLastPlayed(gameEntity)

        // Present game
        selectedGame = game
        showGameView = true
    }
}

// MARK: - Notifications

extension Notification.Name {
    static let gameLibraryUpdated = Notification.Name("gameLibraryUpdated")
}
