//
//  CheatDatabase.swift
//  GameEmulator
//
//  Created by Claude Code
//

import Foundation
import DeltaCore

class CheatDatabase {

    // MARK: - Predefined Cheats

    static let streetFighter2Cheats: [CheatCodeManager.CheatCode] = [
        // Infinite Health Player 1
        CheatCodeManager.CheatCode(
            name: "Infinite Health P1",
            code: "7E0433:60",
            type: .raw,
            isEnabled: false,
            gameType: .snes
        ),

        // Infinite Time
        CheatCodeManager.CheatCode(
            name: "Infinite Time",
            code: "7E0194:99",
            type: .raw,
            isEnabled: false,
            gameType: .snes
        ),

        // Always Full Super Meter P1
        CheatCodeManager.CheatCode(
            name: "Full Super Meter P1",
            code: "7E0436:FF",
            type: .raw,
            isEnabled: false,
            gameType: .snes
        ),

        // One Hit Kills P1
        CheatCodeManager.CheatCode(
            name: "One Hit Kills",
            code: "7E0533:00",
            type: .raw,
            isEnabled: false,
            gameType: .snes
        ),

        // Infinite Health Player 2
        CheatCodeManager.CheatCode(
            name: "Infinite Health P2",
            code: "7E0633:60",
            type: .raw,
            isEnabled: false,
            gameType: .snes
        ),

        // Max Power Always P1
        CheatCodeManager.CheatCode(
            name: "Max Power P1",
            code: "7E0435:FF",
            type: .raw,
            isEnabled: false,
            gameType: .snes
        ),

        // Always Win P1
        CheatCodeManager.CheatCode(
            name: "Always Win Round",
            code: "7E0438:02",
            type: .raw,
            isEnabled: false,
            gameType: .snes
        ),

        // Unlock All Characters
        CheatCodeManager.CheatCode(
            name: "All Characters",
            code: "7E0200:0F",
            type: .raw,
            isEnabled: false,
            gameType: .snes
        )
    ]

    // MARK: - Database Methods

    static func getCheats(for gameName: String, gameType: GameType) -> [CheatCodeManager.CheatCode] {
        let normalizedName = gameName.lowercased()

        if normalizedName.contains("street fighter") && gameType == .snes {
            return streetFighter2Cheats
        }

        // Add more games here as needed

        return []
    }

    static func importCheats(for game: Game, to manager: CheatCodeManager = .shared) -> Int {
        let availableCheats = getCheats(for: game.name, gameType: game.type)
        var importedCount = 0

        for cheat in availableCheats {
            let result = manager.addCheat(
                name: cheat.name,
                code: cheat.code,
                type: cheat.type,
                gameType: cheat.gameType
            )

            if case .success = result {
                importedCount += 1
            }
        }

        return importedCount
    }

    // MARK: - Generic SNES Cheats (work with many games)

    static let genericSNESCheats: [CheatCodeManager.CheatCode] = [
        CheatCodeManager.CheatCode(
            name: "Slow Motion",
            code: "7E0010:01",
            type: .raw,
            isEnabled: false,
            gameType: .snes
        )
    ]

    // MARK: - Cheat Code Format Examples

    static let exampleCheats: [(name: String, code: String, type: CheatCodeManager.CheatType, description: String)] = [
        (
            name: "Example Action Replay",
            code: "7E0433A5:0060",
            type: .actionReplay,
            description: "Action Replay format: ADDRESS:VALUE"
        ),
        (
            name: "Example GameShark",
            code: "7E0433A5 0060",
            type: .gameShark,
            description: "GameShark format: ADDRESS VALUE (space separated)"
        ),
        (
            name: "Example Raw",
            code: "7E0433:60",
            type: .raw,
            description: "Raw format: ADDRESS:VALUE (most common)"
        )
    ]
}

// MARK: - CheatDatabase Extension for ViewModel

extension CheatDatabase {

    static func getAvailableCheatsForCurrentGame(_ game: Game?) -> [CheatCodeManager.CheatCode] {
        guard let game = game else { return [] }
        return getCheats(for: game.name, gameType: game.type)
    }

    static func hasBuiltInCheats(for game: Game?) -> Bool {
        guard let game = game else { return false }
        return !getCheats(for: game.name, gameType: game.type).isEmpty
    }
}
