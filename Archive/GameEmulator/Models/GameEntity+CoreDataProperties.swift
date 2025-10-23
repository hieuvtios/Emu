//
//  GameEntity+CoreDataProperties.swift
//  GameEmulator
//
//  Created by Claude Code on 10/12/25.
//

import Foundation
import CoreData

extension GameEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameEntity> {
        return NSFetchRequest<GameEntity>(entityName: "GameEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var fileName: String
    @NSManaged public var fileExtension: String
    @NSManaged public var gameType: String
    @NSManaged public var dateAdded: Date
    @NSManaged public var lastPlayed: Date?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var artworkData: Data?
}
