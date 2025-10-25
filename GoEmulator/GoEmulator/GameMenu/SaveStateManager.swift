//
//  SaveStateManager.swift
//  GameEmulator
//
//  Created by Claude Code
//

import Foundation
import UIKit
import DeltaCore

class SaveStateManager {

    // MARK: - SaveState Model
    struct SaveStateInfo: Codable, Identifiable {
        let id: UUID
        let timestamp: Date
        let gameTitle: String
        let gameFileURL: URL
        let slotNumber: Int
        var thumbnailPath: String?

        var saveStateURL: URL {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return documentsPath.appendingPathComponent("SaveStates").appendingPathComponent("\(id.uuidString).sav")
        }

        var thumbnailURL: URL? {
            guard let path = thumbnailPath else { return nil }
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return documentsPath.appendingPathComponent("SaveStates").appendingPathComponent(path)
        }
    }

    // MARK: - Properties
    static let shared = SaveStateManager()

    private let saveStatesDirectory: URL
    private let metadataFileName = "metadata.json"
    private var saveStates: [SaveStateInfo] = []

    private init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        saveStatesDirectory = documentsPath.appendingPathComponent("SaveStates")

        // Create save states directory if it doesn't exist
        try? FileManager.default.createDirectory(at: saveStatesDirectory, withIntermediateDirectories: true)

        loadMetadata()
    }

    // MARK: - Save State Operations

    func saveState(for game: Game, emulatorCore: EmulatorCore, slotNumber: Int, screenshot: UIImage?) -> Result<SaveStateInfo, Error> {
        do {
            let saveStateInfo = SaveStateInfo(
                id: UUID(),
                timestamp: Date(),
                gameTitle: game.name,
                gameFileURL: game.fileURL,
                slotNumber: slotNumber
            )

            // Pause emulator before saving to prevent crashes
            let wasPaused = emulatorCore.state == .paused || emulatorCore.state == .stopped
            if !wasPaused {
                emulatorCore.pause()
            }

            // Save the actual emulator state
            let saveState = PersistentSaveState(fileURL: saveStateInfo.saveStateURL, gameType: game.type)
            try emulatorCore.saveGameState(to: saveState.fileURL)

            // Resume if it was running before
            if !wasPaused && emulatorCore.state == .paused {
                emulatorCore.resume()
            }

            // Save screenshot if provided
            var updatedInfo = saveStateInfo
            if let screenshot = screenshot {
                let thumbnailFileName = "\(saveStateInfo.id.uuidString)_thumb.png"
                let thumbnailURL = saveStatesDirectory.appendingPathComponent(thumbnailFileName)

                if let data = screenshot.pngData() {
                    try data.write(to: thumbnailURL)
                    updatedInfo.thumbnailPath = thumbnailFileName
                }
            }

            // Remove existing save state in the same slot for this game
            if let existingIndex = saveStates.firstIndex(where: { $0.gameFileURL == game.fileURL && $0.slotNumber == slotNumber }) {
                let oldState = saveStates[existingIndex]
                try? FileManager.default.removeItem(at: oldState.saveStateURL)
                if let thumbURL = oldState.thumbnailURL {
                    try? FileManager.default.removeItem(at: thumbURL)
                }
                saveStates.remove(at: existingIndex)
            }

            // Add new save state
            saveStates.append(updatedInfo)
            saveMetadata()

            return .success(updatedInfo)
        } catch {
            return .failure(error)
        }
    }

    func loadState(_ saveStateInfo: SaveStateInfo, emulatorCore: EmulatorCore) -> Result<Void, Error> {
        do {
            // Validate save state file exists
            guard FileManager.default.fileExists(atPath: saveStateInfo.saveStateURL.path) else {
                throw NSError(domain: "SaveStateManager", code: 404, userInfo: [
                    NSLocalizedDescriptionKey: "Save state file not found",
                    NSLocalizedFailureReasonErrorKey: "The save state file does not exist at path: \(saveStateInfo.saveStateURL.path)"
                ])
            }

            // Validate emulator is in a valid state
            guard emulatorCore.state != .stopped else {
                throw NSError(domain: "SaveStateManager", code: 400, userInfo: [
                    NSLocalizedDescriptionKey: "Cannot load save state",
                    NSLocalizedFailureReasonErrorKey: "Emulator is not running. Please start the game first."
                ])
            }

            // Store the original state to determine if we need to resume
            let wasRunning = emulatorCore.state == .running

            // CRITICAL: Pause the emulator before loading
            // This ensures the emulation thread is not actively running when we load the state
            if wasRunning {
                let pauseSuccess = emulatorCore.pause()
                guard pauseSuccess else {
                    throw NSError(domain: "SaveStateManager", code: 500, userInfo: [
                        NSLocalizedDescriptionKey: "Failed to pause emulator",
                        NSLocalizedFailureReasonErrorKey: "Could not pause emulator before loading save state"
                    ])
                }

                // IMPORTANT: Add a small delay to ensure pause operation fully completes
                // The pause() method waits for a frame update, but we need to ensure
                // the emulation lock is released and the thread is stable
                Thread.sleep(forTimeInterval: 0.1) // 100ms delay
            }

            // Double-check the emulator is actually paused
            guard emulatorCore.state == .paused || emulatorCore.state == .running else {
                throw NSError(domain: "SaveStateManager", code: 500, userInfo: [
                    NSLocalizedDescriptionKey: "Emulator state is invalid",
                    NSLocalizedFailureReasonErrorKey: "Expected emulator to be paused or running, but state is: \(emulatorCore.state.rawValue)"
                ])
            }

            // Load the save state
            // This will call DeltaCore's load() method which:
            // 1. Loads the emulator state from file
            // 2. Updates cheats
            // 3. Resets and reactivates controller inputs
            try emulatorCore.loadGameState(from: saveStateInfo.saveStateURL)

            // Add a small delay after loading to let the state stabilize
            Thread.sleep(forTimeInterval: 0.05) // 50ms delay

            // Resume if it was running before
            if wasRunning {
                let resumeSuccess = emulatorCore.resume()
                if !resumeSuccess {
                    // If resume fails, log but don't throw - the state is loaded successfully
                    print("Warning: Failed to resume emulator after loading save state")
                } else {
                    // Add a small delay after resume to ensure smooth transition
                    Thread.sleep(forTimeInterval: 0.05) // 50ms delay
                }
            }

            return .success(())
        } catch let error as NSError {
            // Log detailed error information for debugging
            print("SaveStateManager.loadState failed:")
            print("  Error domain: \(error.domain)")
            print("  Error code: \(error.code)")
            print("  Description: \(error.localizedDescription)")
            if let reason = error.localizedFailureReason {
                print("  Reason: \(reason)")
            }
            return .failure(error)
        } catch {
            // Handle any other errors
            print("SaveStateManager.loadState unexpected error: \(error)")
            return .failure(error)
        }
    }

    func deleteSaveState(_ saveStateInfo: SaveStateInfo) {
        // Remove files
        try? FileManager.default.removeItem(at: saveStateInfo.saveStateURL)
        if let thumbnailURL = saveStateInfo.thumbnailURL {
            try? FileManager.default.removeItem(at: thumbnailURL)
        }

        // Remove from array
        if let index = saveStates.firstIndex(where: { $0.id == saveStateInfo.id }) {
            saveStates.remove(at: index)
            saveMetadata()
        }
    }

    func getSaveStates(for game: Game) -> [SaveStateInfo] {
        return saveStates
            .filter { $0.gameFileURL == game.fileURL }
            .sorted { $0.slotNumber < $1.slotNumber }
    }

    func getAllSaveStates() -> [SaveStateInfo] {
        return saveStates.sorted { $0.timestamp > $1.timestamp }
    }

    func getThumbnail(for saveStateInfo: SaveStateInfo) -> UIImage? {
        guard let thumbnailURL = saveStateInfo.thumbnailURL,
              let data = try? Data(contentsOf: thumbnailURL) else {
            return nil
        }
        return UIImage(data: data)
    }

    // MARK: - Metadata Management

    private func saveMetadata() {
        let metadataURL = saveStatesDirectory.appendingPathComponent(metadataFileName)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        if let data = try? encoder.encode(saveStates) {
            try? data.write(to: metadataURL)
        }
    }

    private func loadMetadata() {
        let metadataURL = saveStatesDirectory.appendingPathComponent(metadataFileName)
        guard let data = try? Data(contentsOf: metadataURL) else {
            saveStates = []
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        saveStates = (try? decoder.decode([SaveStateInfo].self, from: data)) ?? []
    }

    // MARK: - Helper

    struct PersistentSaveState: SaveStateProtocol {
        var fileURL: URL
        var gameType: GameType
        var isSaved: Bool = false
    }
}
