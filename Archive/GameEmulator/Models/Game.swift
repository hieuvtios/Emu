//
//  Game.swift
//  GameEmulator
//
//  Created by Đỗ Việt on 27/9/25.
//

import Foundation
import DeltaCore

struct Game: GameProtocol {
    var type: GameType = .n64
    // nes game: mario.nes
    var fileURL: URL {
//        return Bundle.main.url(forResource: "Contra", withExtension: "nes")!
//        return Bundle.main.url(forResource: "demo", withExtension: "smc")!
//        return Bundle.main.url(forResource: "poke", withExtension: "gbc")!
        return Bundle.main.url(forResource: "kombat", withExtension: "z64")!
    }
    
    var name: String = "Demo SNES"
}
