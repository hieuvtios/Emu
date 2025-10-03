//
//  GameMenuViewModel.swift
//  GameEmulator
//
//  Created by Claude Code
//

import Foundation
import UIKit
import Combine
import DeltaCore

class GameMenuViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var saveStates: [SaveStateManager.SaveStateInfo] = []
    @Published var cheats: [CheatCodeManager.CheatCode] = []
    @Published var currentSpeed: EmulatorCore.EmulationSpeed = .normal
    @Published var showingSaveConfirmation = false
    @Published var showingLoadConfirmation = false
    @Published var showingCheatInput = false
    @Published var showingCheatDatabase = false
    @Published var showingScreenshotSuccess = false
    @Published var errorMessage: String?
    @Published var availableBuiltInCheats: [CheatCodeManager.CheatCode] = []

    // MARK: - Properties
    private weak var emulatorCore: EmulatorCore?
    private weak var gameView: GameView?
    private var game: Game?

    private let saveStateManager = SaveStateManager.shared
    private let cheatCodeManager = CheatCodeManager.shared

    // MARK: - Initialization

    func configure(emulatorCore: EmulatorCore?, gameView: GameView?, game: Game?) {
        self.emulatorCore = emulatorCore
        self.gameView = gameView
        self.game = game

        if let game = game {
            loadSaveStates(for: game)
            loadCheats(for: game)
            loadAvailableBuiltInCheats(for: game)
        }

        if let core = emulatorCore {
            currentSpeed = core.currentSpeed
        }
    }

    // MARK: - Built-in Cheats

    func loadAvailableBuiltInCheats(for game: Game) {
        availableBuiltInCheats = CheatDatabase.getCheats(for: game.name, gameType: game.type)
    }

    func importBuiltInCheat(_ cheat: CheatCodeManager.CheatCode) {
        guard let game = game else { return }

        let result = cheatCodeManager.addCheat(
            name: cheat.name,
            code: cheat.code,
            type: cheat.type,
            gameType: game.type
        )

        switch result {
        case .success(_):
            loadCheats(for: game)
            showingCheatDatabase = false

        case .failure(let error):
            errorMessage = "Failed to import cheat: \(error.localizedDescription)"
        }
    }

    func importAllBuiltInCheats() {
        guard let game = game else { return }

        let count = CheatDatabase.importCheats(for: game, to: cheatCodeManager)
        loadCheats(for: game)
        showingCheatDatabase = false

        if count > 0 {
            // Success - no error message needed
            print("Imported \(count) cheats")
        } else {
            errorMessage = "No cheats available for this game"
        }
    }

    // MARK: - Save States

    func loadSaveStates(for game: Game) {
        saveStates = saveStateManager.getSaveStates(for: game)
    }

    func saveState(slotNumber: Int) {
        guard let game = game, let core = emulatorCore else {
            errorMessage = "Unable to save state: game or emulator not available"
            return
        }

        // Capture screenshot
        let screenshot = gameView.flatMap { core.captureScreenshot(from: $0) }

        let result = saveStateManager.saveState(for: game, emulatorCore: core, slotNumber: slotNumber, screenshot: screenshot)

        switch result {
        case .success(let saveState):
            showingSaveConfirmation = true
            loadSaveStates(for: game)
            print("Save state created: \(saveState.id)")

        case .failure(let error):
            errorMessage = "Failed to save state: \(error.localizedDescription)"
        }
    }

    func loadState(_ saveState: SaveStateManager.SaveStateInfo) {
        guard let core = emulatorCore else {
            errorMessage = "Unable to load state: emulator not available"
            print("LoadState error: Emulator core is nil")
            return
        }

        // Log the load attempt
        print("Loading save state:")
        print("  ID: \(saveState.id)")
        print("  Slot: \(saveState.slotNumber)")
        print("  Game: \(saveState.gameTitle)")
        print("  Timestamp: \(saveState.timestamp)")
        print("  Emulator state before: \(core.state.rawValue)")

        // Perform the load operation on the main thread
        // The SaveStateManager will handle pause/resume internally
        let result = saveStateManager.loadState(saveState, emulatorCore: core)

        switch result {
        case .success():
            // Show success confirmation
            showingLoadConfirmation = true
            print("Save state loaded successfully: \(saveState.id)")
            print("  Emulator state after: \(core.state.rawValue)")

        case .failure(let error):
            // Show detailed error message to user
            let nsError = error as NSError
            var message = "Failed to load state: \(error.localizedDescription)"

            // Add more context if available
            if let reason = nsError.localizedFailureReason {
                message += "\n\nReason: \(reason)"
            }

            errorMessage = message

            // Log detailed error for debugging
            print("LoadState error:")
            print("  Error domain: \(nsError.domain)")
            print("  Error code: \(nsError.code)")
            print("  Description: \(error.localizedDescription)")
            if let reason = nsError.localizedFailureReason {
                print("  Reason: \(reason)")
            }
            print("  Emulator state: \(core.state.rawValue)")
        }
    }

    func deleteState(_ saveState: SaveStateManager.SaveStateInfo) {
        saveStateManager.deleteSaveState(saveState)

        if let game = game {
            loadSaveStates(for: game)
        }
    }

    func getThumbnail(for saveState: SaveStateManager.SaveStateInfo) -> UIImage? {
        return saveStateManager.getThumbnail(for: saveState)
    }

    // MARK: - Cheat Codes

    func loadCheats(for game: Game) {
        cheats = cheatCodeManager.getCheats(for: game.type)
    }

    func addCheat(name: String, code: String, type: CheatCodeManager.CheatType) {
        guard let game = game else {
            errorMessage = "No game loaded"
            return
        }

        let result = cheatCodeManager.addCheat(name: name, code: code, type: type, gameType: game.type)

        switch result {
        case .success(_):
            loadCheats(for: game)
            showingCheatInput = false

        case .failure(let error):
            errorMessage = "Failed to add cheat: \(error.localizedDescription)"
        }
    }

    func toggleCheat(_ cheat: CheatCodeManager.CheatCode) {
        cheatCodeManager.toggleCheat(cheat, emulatorCore: emulatorCore)

        if let game = game {
            loadCheats(for: game)
        }
    }

    func deleteCheat(_ cheat: CheatCodeManager.CheatCode) {
        cheatCodeManager.deleteCheat(cheat)

        if let game = game {
            loadCheats(for: game)
        }
    }

    // MARK: - Speed Control

    func toggleSpeed() {
        guard let core = emulatorCore else { return }

        core.toggleSpeed()
        currentSpeed = core.currentSpeed
    }

    func setSpeed(_ speed: EmulatorCore.EmulationSpeed) {
        guard let core = emulatorCore else { return }

        core.setSpeed(speed)
        currentSpeed = speed
    }

    func resetSpeed() {
        guard let core = emulatorCore else { return }

        core.resetSpeed()
        currentSpeed = core.currentSpeed
    }

    // MARK: - Screenshot

    func captureScreenshot() {
        guard let core = emulatorCore, let gameView = gameView else {
            errorMessage = "Unable to capture screenshot: game view not available"
            return
        }

        core.saveScreenshotToPhotos(from: gameView) { [weak self] result in
            switch result {
            case .success():
                self?.showingScreenshotSuccess = true
                print("Screenshot saved to Photos")

            case .failure(let error):
                self?.errorMessage = "Failed to save screenshot: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - Menu Actions

    func quickSave() {
        saveState(slotNumber: 0) // Slot 0 is quick save
    }

    func quickLoad() {
        guard let game = game else { return }

        if let quickSaveState = saveStateManager.getSaveStates(for: game).first(where: { $0.slotNumber == 0 }) {
            loadState(quickSaveState)
        } else {
            errorMessage = "No quick save found"
        }
    }

    // MARK: - Cleanup

    func cleanup() {
        // Stop all active cheats when menu is dismissed
        cheatCodeManager.stopAllCheats()
    }
}
