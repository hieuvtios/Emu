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

    /// Handle imported game files from DocumentPicker
    func handleImportedGames(_ urls: [URL]) {
        print("🎮 TabViewModel handling \(urls.count) imported game(s)")

        guard let firstURL = urls.first else {
            print("❌ No URLs provided")
            return
        }

        print("📍 Game file URL: \(firstURL.path)")
        print("📂 File exists: \(FileManager.default.fileExists(atPath: firstURL.path))")

        // Detect game type from file extension
        let fileExtension = firstURL.pathExtension
        print("📝 File extension: \(fileExtension)")

        guard let gameType = GameType(fileExtension: fileExtension) else {
            print("❌ Unsupported game file type: \(fileExtension)")
            return
        }

        print("🎯 Detected game type: \(gameType)")

        // Create Game instance with imported file
        let game = Game(fileURL: firstURL, type: gameType)
        selectedGame = game

        print("✅ Created game: \(game.name)")
        print("🚀 Presenting game fullscreen...")

        // Present game fullscreen
        showGameView = true
    }
}
