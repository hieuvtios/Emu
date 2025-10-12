//
//  GameManager.swift
//  GameEmulator
//
//  Created by Claude Code on 10/12/25.
//

import Foundation
import CoreData
import DeltaCore
import UIKit

class GameManager {
    static let shared = GameManager()

    private let persistenceController = PersistenceController.shared

    /// Directory where game files are stored
    var gamesDirectory: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let gamesURL = documentsURL.appendingPathComponent("Games", isDirectory: true)

        // Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: gamesURL.path) {
            try? FileManager.default.createDirectory(at: gamesURL, withIntermediateDirectories: true)
        }

        return gamesURL
    }

    private init() {}

    // MARK: - Import Game

    /// Import a game from a URL and save to CoreData
    /// - Parameters:
    ///   - sourceURL: The URL of the imported game file
    ///   - gameType: The detected game type
    /// - Returns: The created GameEntity or nil if failed
    func importGame(from sourceURL: URL, gameType: GameType) -> GameEntity? {
        print("📥 Importing game from: \(sourceURL.lastPathComponent)")

        // Start accessing security-scoped resource
        let didStartAccessing = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        // Generate unique filename
        let fileName = generateUniqueFileName(for: sourceURL)
        let destinationURL = gamesDirectory.appendingPathComponent(fileName)

        // Copy file to app's documents directory
        do {
            // Check if file already exists at destination
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }

            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            print("✅ Game file copied to: \(destinationURL.path)")
        } catch {
            print("❌ Failed to copy game file: \(error.localizedDescription)")
            return nil
        }

        // Create CoreData entity
        let context = persistenceController.container.viewContext
        let gameEntity = GameEntity(context: context)

        gameEntity.id = UUID()
        gameEntity.name = sourceURL.deletingPathExtension().lastPathComponent
        gameEntity.fileName = fileName
        gameEntity.fileExtension = sourceURL.pathExtension
        gameEntity.gameType = gameType.rawValue
        gameEntity.dateAdded = Date()
        gameEntity.isFavorite = false

        // Save to CoreData
        persistenceController.save()

        print("✅ Game saved to CoreData: \(gameEntity.name)")
        return gameEntity
    }

    // MARK: - Fetch Games

    /// Fetch all games from CoreData
    func fetchAllGames() -> [GameEntity] {
        return persistenceController.fetchAllGames()
    }

    /// Fetch favorite games
    func fetchFavoriteGames() -> [GameEntity] {
        let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == YES")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \GameEntity.dateAdded, ascending: false)]

        do {
            return try persistenceController.container.viewContext.fetch(fetchRequest)
        } catch {
            print("❌ Failed to fetch favorite games: \(error.localizedDescription)")
            return []
        }
    }

    /// Fetch recently played games
    func fetchRecentlyPlayedGames(limit: Int = 5) -> [GameEntity] {
        let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lastPlayed != nil")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \GameEntity.lastPlayed, ascending: false)]
        fetchRequest.fetchLimit = limit

        do {
            return try persistenceController.container.viewContext.fetch(fetchRequest)
        } catch {
            print("❌ Failed to fetch recently played games: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Update Game

    /// Toggle favorite status
    func toggleFavorite(_ game: GameEntity) {
        game.isFavorite.toggle()
        persistenceController.save()
        print("⭐️ Game '\(game.name)' favorite status: \(game.isFavorite)")
    }

    /// Update last played date
    func updateLastPlayed(_ game: GameEntity) {
        game.lastPlayed = Date()
        persistenceController.save()
        print("🎮 Updated last played for '\(game.name)'")
    }

    // MARK: - Delete Game

    /// Delete a game and its file
    func deleteGame(_ game: GameEntity) {
        // Delete file from disk
        let fileURL = gamesDirectory.appendingPathComponent(game.fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("🗑️ Deleted game file: \(game.fileName)")
            } catch {
                print("❌ Failed to delete game file: \(error.localizedDescription)")
            }
        }

        // Delete from CoreData
        persistenceController.deleteGame(game)
        print("✅ Game '\(game.name)' deleted from CoreData")
    }

    // MARK: - Helpers

    /// Generate a unique filename to avoid conflicts
    private func generateUniqueFileName(for url: URL) -> String {
        let fileExtension = url.pathExtension
        let baseName = url.deletingPathExtension().lastPathComponent
        var fileName = url.lastPathComponent
        var counter = 1

        // Check if file exists and add counter if needed
        while FileManager.default.fileExists(atPath: gamesDirectory.appendingPathComponent(fileName).path) {
            fileName = "\(baseName) (\(counter)).\(fileExtension)"
            counter += 1
        }

        return fileName
    }

    /// Generate thumbnail from game artwork (placeholder for future implementation)
    private func generateThumbnail(for url: URL) -> Data? {
        // TODO: Implement thumbnail generation from ROM header or custom artwork
        return nil
    }
}
