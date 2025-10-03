//
//  CheatCodeManager.swift
//  GameEmulator
//
//  Created by Claude Code
//

import Foundation
import DeltaCore

class CheatCodeManager {

    // MARK: - CheatCode Model
    struct CheatCode: Codable, Identifiable {
        let id: UUID
        var name: String
        var code: String
        var type: CheatType
        var isEnabled: Bool
        let gameType: GameType

        init(id: UUID = UUID(), name: String, code: String, type: CheatType, isEnabled: Bool = false, gameType: GameType) {
            self.id = id
            self.name = name
            self.code = code
            self.type = type
            self.isEnabled = isEnabled
            self.gameType = gameType
        }
    }

    enum CheatType: String, Codable {
        case actionReplay = "Action Replay"
        case gameShark = "GameShark"
        case gameBoy = "Game Boy"
        case raw = "Raw Memory"

        var codeFormat: String {
            switch self {
            case .actionReplay: return "XXXXXXXX:XXXX"
            case .gameShark: return "XXXXXXXX XXXX"
            case .gameBoy: return "XXX-XXX-XXX"
            case .raw: return "Address:Value"
            }
        }
    }

    // MARK: - Properties
    static let shared = CheatCodeManager()

    private let cheatsDirectory: URL
    private let cheatsFileName = "cheats.json"
    private var cheats: [CheatCode] = []
    private var activeCheatTimers: [UUID: Timer] = [:]

    private init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        cheatsDirectory = documentsPath.appendingPathComponent("Cheats")

        // Create cheats directory if it doesn't exist
        try? FileManager.default.createDirectory(at: cheatsDirectory, withIntermediateDirectories: true)

        loadCheats()
    }

    // MARK: - Cheat Management

    func addCheat(name: String, code: String, type: CheatType, gameType: GameType) -> Result<CheatCode, Error> {
        // Validate cheat code format
        guard isValidCheatCode(code, type: type) else {
            return .failure(NSError(domain: "CheatCodeManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid cheat code format"]))
        }

        let cheat = CheatCode(name: name, code: code, type: type, gameType: gameType)
        cheats.append(cheat)
        saveCheats()

        return .success(cheat)
    }

    func updateCheat(_ cheat: CheatCode) {
        if let index = cheats.firstIndex(where: { $0.id == cheat.id }) {
            cheats[index] = cheat
            saveCheats()
        }
    }

    func deleteCheat(_ cheat: CheatCode) {
        if let index = cheats.firstIndex(where: { $0.id == cheat.id }) {
            // Stop applying cheat if it's active
            if cheat.isEnabled {
                stopApplyingCheat(cheat)
            }
            cheats.remove(at: index)
            saveCheats()
        }
    }

    func getCheats(for gameType: GameType) -> [CheatCode] {
        return cheats.filter { $0.gameType == gameType }
    }

    func toggleCheat(_ cheat: CheatCode, emulatorCore: EmulatorCore?) {
        guard let index = cheats.firstIndex(where: { $0.id == cheat.id }) else { return }

        cheats[index].isEnabled.toggle()
        let updatedCheat = cheats[index]

        if updatedCheat.isEnabled {
            applyCheat(updatedCheat, emulatorCore: emulatorCore)
        } else {
            stopApplyingCheat(updatedCheat)
        }

        saveCheats()
    }

    // MARK: - Cheat Application

    private func applyCheat(_ cheat: CheatCode, emulatorCore: EmulatorCore?) {
        guard let core = emulatorCore else { return }

        // Parse the cheat code
        guard let (address, value) = parseCheatCode(cheat.code, type: cheat.type) else {
            print("Failed to parse cheat code: \(cheat.code)")
            return
        }

        // Apply cheat using a timer to continuously write to memory
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.writeMemory(address: address, value: value, emulatorCore: core)
        }

        activeCheatTimers[cheat.id] = timer
    }

    private func stopApplyingCheat(_ cheat: CheatCode) {
        activeCheatTimers[cheat.id]?.invalidate()
        activeCheatTimers.removeValue(forKey: cheat.id)
    }

    func stopAllCheats() {
        for timer in activeCheatTimers.values {
            timer.invalidate()
        }
        activeCheatTimers.removeAll()
    }

    private func writeMemory(address: UInt32, value: UInt32, emulatorCore: EmulatorCore) {
        // This is a simplified implementation
        // In a real implementation, you would need to access the emulator core's memory
        // through DeltaCore's memory access APIs (if available)

        // Note: DeltaCore may not expose direct memory access APIs
        // This would need to be implemented at the core level for each emulator
        print("Writing cheat: Address=\(String(format: "%08X", address)), Value=\(String(format: "%08X", value))")
    }

    // MARK: - Cheat Code Validation & Parsing

    private func isValidCheatCode(_ code: String, type: CheatType) -> Bool {
        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)

        switch type {
        case .actionReplay:
            // Format: XXXXXXXX:XXXX
            let pattern = "^[0-9A-Fa-f]{8}:[0-9A-Fa-f]{4}$"
            return trimmedCode.range(of: pattern, options: .regularExpression) != nil

        case .gameShark:
            // Format: XXXXXXXX XXXX
            let pattern = "^[0-9A-Fa-f]{8}\\s+[0-9A-Fa-f]{4}$"
            return trimmedCode.range(of: pattern, options: .regularExpression) != nil

        case .gameBoy:
            // Format: XXX-XXX-XXX
            let pattern = "^[0-9A-Fa-f]{3}-[0-9A-Fa-f]{3}-[0-9A-Fa-f]{3}$"
            return trimmedCode.range(of: pattern, options: .regularExpression) != nil

        case .raw:
            // Format: Address:Value (flexible hex format)
            let pattern = "^[0-9A-Fa-f]+:[0-9A-Fa-f]+$"
            return trimmedCode.range(of: pattern, options: .regularExpression) != nil
        }
    }

    private func parseCheatCode(_ code: String, type: CheatType) -> (address: UInt32, value: UInt32)? {
        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)

        switch type {
        case .actionReplay:
            let parts = trimmedCode.split(separator: ":")
            guard parts.count == 2,
                  let address = UInt32(parts[0], radix: 16),
                  let value = UInt32(parts[1], radix: 16) else {
                return nil
            }
            return (address, value)

        case .gameShark:
            let parts = trimmedCode.split(separator: " ")
            guard parts.count == 2,
                  let address = UInt32(parts[0], radix: 16),
                  let value = UInt32(parts[1], radix: 16) else {
                return nil
            }
            return (address, value)

        case .gameBoy:
            let cleaned = trimmedCode.replacingOccurrences(of: "-", with: "")
            guard let address = UInt32(cleaned.prefix(6), radix: 16),
                  let value = UInt32(cleaned.suffix(3), radix: 16) else {
                return nil
            }
            return (address, value)

        case .raw:
            let parts = trimmedCode.split(separator: ":")
            guard parts.count == 2,
                  let address = UInt32(parts[0], radix: 16),
                  let value = UInt32(parts[1], radix: 16) else {
                return nil
            }
            return (address, value)
        }
    }

    // MARK: - Persistence

    private func saveCheats() {
        let cheatsURL = cheatsDirectory.appendingPathComponent(cheatsFileName)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let data = try? encoder.encode(cheats) {
            try? data.write(to: cheatsURL)
        }
    }

    private func loadCheats() {
        let cheatsURL = cheatsDirectory.appendingPathComponent(cheatsFileName)
        guard let data = try? Data(contentsOf: cheatsURL) else {
            cheats = []
            return
        }

        let decoder = JSONDecoder()
        cheats = (try? decoder.decode([CheatCode].self, from: data)) ?? []
    }
}
