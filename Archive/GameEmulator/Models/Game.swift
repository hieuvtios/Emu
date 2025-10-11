//
//  Game.swift
//  GameEmulator
//
//  Created by Đỗ Việt on 27/9/25.
//

import Foundation
import DeltaCore

struct Game: GameProtocol {
    var type: GameType
    var fileURL: URL
    var name: String

    // MARK: - Initializers

    /// Custom initializer for imported games
    init(fileURL: URL, type: GameType, name: String? = nil) {
        self.fileURL = fileURL
        self.type = type
        self.name = name ?? fileURL.deletingPathExtension().lastPathComponent
    }

    /// Default initializer with hardcoded game (for backward compatibility)
    init() {
        self.type = .gbc
        // nes game: mario.nes
        self.fileURL = Bundle.main.url(forResource: "poke", withExtension: "gbc")!
//        self.fileURL = Bundle.main.url(forResource: "Contra", withExtension: "nes")!
//        self.fileURL = Bundle.main.url(forResource: "demo", withExtension: "smc")!
//        self.fileURL = Bundle.main.url(forResource: "kombat", withExtension: "z64")!
//        self.fileURL = Bundle.main.url(forResource: "street", withExtension: "md")!
//        self.fileURL = Bundle.main.url(forResource: "pokemon", withExtension: "gba")!
//        self.fileURL = Bundle.main.url(forResource: "callofduty", withExtension: "nds")!
        self.name = "Pokémon"
    }
}
