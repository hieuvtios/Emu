//
//  Game.swift
//  GameEmulator
//
//  Created by Đỗ Việt on 27/9/25.
//

import Foundation
import DeltaCore

struct Game: GameProtocol {
    var type: GameType = .snes
    // nes game: mario.nes
    var fileURL: URL {
//        return Bundle.main.url(forResource: "Contra", withExtension: "nes")!
        return Bundle.main.url(forResource: "demo", withExtension: "smc")!
    }
    
    var name: String = "Demo SNES"
}
