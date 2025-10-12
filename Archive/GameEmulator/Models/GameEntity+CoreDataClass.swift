//
//  GameEntity+CoreDataClass.swift
//  GameEmulator
//
//  Created by Claude Code on 10/12/25.
//

import Foundation
import CoreData
import DeltaCore

@objc(GameEntity)
public class GameEntity: NSManagedObject, Identifiable {

    /// Convert GameEntity to Game struct for playing
    func toGame() -> Game? {
        let gameType = GameType(rawValue: self.gameType)

        let fileURL = GameManager.shared.gamesDirectory.appendingPathComponent(fileName)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("❌ Game file does not exist: \(fileURL.path)")
            return nil
        }

        return Game(fileURL: fileURL, type: gameType, name: name)
    }
}
