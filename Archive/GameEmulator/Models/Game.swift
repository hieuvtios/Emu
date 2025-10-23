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
        self.type = .gba
        // GBA game: pokemon.gba (add ROM file to project)
        self.fileURL = Bundle.main.url(forResource: "pokemon", withExtension: "gba")!

        // Other system ROMs (uncomment to test):
//        self.type = .gbc
//        self.fileURL = Bundle.main.url(forResource: "poke", withExtension: "gbc")!
//        self.type = .nes
//        self.fileURL = Bundle.main.url(forResource: "Contra", withExtension: "nes")!
//        self.type = .snes
//        self.fileURL = Bundle.main.url(forResource: "demo", withExtension: "smc")!
//        self.type = .n64
//        self.fileURL = Bundle.main.url(forResource: "kombat", withExtension: "z64")!
//        self.type = .genesis
//        self.fileURL = Bundle.main.url(forResource: "street", withExtension: "md")!
//        self.type = .ds
//        self.fileURL = Bundle.main.url(forResource: "callofduty", withExtension: "nds")!

        self.name = "Pokémon"
    }
}
