//
//  PersistenceController.swift
//  GameEmulator
//
//  Created by Claude Code on 10/12/25.
//

import CoreData
import Foundation

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GameEmulator")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    /// Save context if there are changes
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
                print("✅ CoreData context saved successfully")
            } catch {
                print("❌ Failed to save CoreData context: \(error.localizedDescription)")
            }
        }
    }

    /// Fetch all games ordered by date added (newest first)
    func fetchAllGames() -> [GameEntity] {
        let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \GameEntity.dateAdded, ascending: false)]

        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print("❌ Failed to fetch games: \(error.localizedDescription)")
            return []
        }
    }

    /// Delete a game entity
    func deleteGame(_ game: GameEntity) {
        container.viewContext.delete(game)
        save()
    }

    /// Delete all games (for testing)
    func deleteAllGames() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GameEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.viewContext.execute(deleteRequest)
            save()
            print("✅ All games deleted from CoreData")
        } catch {
            print("❌ Failed to delete all games: \(error.localizedDescription)")
        }
    }

    // MARK: - Preview Support

    /// Preview instance with sample data
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        // Create sample games for preview
        for i in 0..<3 {
            let game = GameEntity(context: context)
            game.id = UUID()
            game.name = "Sample Game \(i + 1)"
            game.fileName = "sample\(i + 1).smc"
            game.fileExtension = "smc"
            game.gameType = "com.rileytestut.delta.game.snes"
            game.dateAdded = Date().addingTimeInterval(Double(-i * 86400))
            game.isFavorite = i == 0
        }

        do {
            try context.save()
        } catch {
            fatalError("Failed to create preview data: \(error.localizedDescription)")
        }

        return controller
    }()
}
