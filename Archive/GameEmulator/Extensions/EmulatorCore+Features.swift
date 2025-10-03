//
//  EmulatorCore+Features.swift
//  GameEmulator
//
//  Created by Claude Code
//

import Foundation
import UIKit
import DeltaCore
import Photos

extension EmulatorCore {

    // MARK: - Speed Control

    enum EmulationSpeed: Double, CaseIterable {
        case normal = 1.0
        case fast2x = 2.0
        case fast4x = 4.0

        var displayName: String {
            switch self {
            case .normal: return "1x"
            case .fast2x: return "2x"
            case .fast4x: return "4x"
            }
        }

        var next: EmulationSpeed {
            switch self {
            case .normal: return .fast2x
            case .fast2x: return .fast4x
            case .fast4x: return .normal
            }
        }
    }

    private static var speedKey: UInt8 = 0
    private static var originalRateKey: UInt8 = 0

    var currentSpeed: EmulationSpeed {
        get {
            return (objc_getAssociatedObject(self, &EmulatorCore.speedKey) as? EmulationSpeed) ?? .normal
        }
        set {
            objc_setAssociatedObject(self, &EmulatorCore.speedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            applySpeed(newValue)
        }
    }

    private var originalRate: Double {
        get {
            if let rate = objc_getAssociatedObject(self, &EmulatorCore.originalRateKey) as? Double {
                return rate
            }
            return self.rate
        }
        set {
            objc_setAssociatedObject(self, &EmulatorCore.originalRateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setSpeed(_ speed: EmulationSpeed) {
        // Store original rate if this is the first time
        if currentSpeed == .normal && speed != .normal {
            originalRate = self.rate
        }

        currentSpeed = speed
    }

    func toggleSpeed() {
        setSpeed(currentSpeed.next)
    }

    private func applySpeed(_ speed: EmulationSpeed) {
        let targetRate = originalRate * speed.rawValue
        self.rate = targetRate

        // Adjust audio if needed to prevent crackling
        if speed != .normal {
            // When fast-forwarding, we might want to mute or reduce audio volume
            // This depends on the emulator implementation
        }
    }

    func resetSpeed() {
        setSpeed(.normal)
    }

    // MARK: - Screenshot Capture

    func captureScreenshot(from gameView: GameView) -> UIImage? {
        // Render the current frame to an image
        UIGraphicsBeginImageContextWithOptions(gameView.bounds.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // Render the game view layer
        gameView.layer.render(in: context)

        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }

    func saveScreenshotToPhotos(from gameView: GameView, completion: @escaping (Result<Void, Error>) -> Void) {
        // Check photo library permission
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

        switch status {
        case .authorized, .limited:
            performScreenshotSave(from: gameView, completion: completion)

        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self.performScreenshotSave(from: gameView, completion: completion)
                    } else {
                        completion(.failure(NSError(domain: "EmulatorCore", code: 403, userInfo: [NSLocalizedDescriptionKey: "Photo library access denied"])))
                    }
                }
            }

        case .denied, .restricted:
            completion(.failure(NSError(domain: "EmulatorCore", code: 403, userInfo: [NSLocalizedDescriptionKey: "Photo library access denied"])))

        @unknown default:
            completion(.failure(NSError(domain: "EmulatorCore", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unknown authorization status"])))
        }
    }

    private func performScreenshotSave(from gameView: GameView, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let screenshot = captureScreenshot(from: gameView) else {
            completion(.failure(NSError(domain: "EmulatorCore", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to capture screenshot"])))
            return
        }

        PHPhotoLibrary.shared().performChanges({
            PHAssetCreationRequest.creationRequestForAsset(from: screenshot)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    completion(.success(()))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "EmulatorCore", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unknown error saving screenshot"])))
                }
            }
        }
    }

    // MARK: - Save/Load State Helpers

    func saveGameState(to url: URL) throws {
        // Save emulator state to the specified URL
        // Note: This uses DeltaCore's internal save state mechanism

        // Validate emulator state
        guard self.state != .stopped else {
            throw NSError(domain: "EmulatorCore", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Cannot save state: emulator is stopped"
            ])
        }

        _ = self.saveSaveState(to: url)
    }

    func loadGameState(from url: URL) throws {
        // Load emulator state from the specified URL
        // IMPORTANT: This method should ONLY be called when the emulator is paused
        // The caller (SaveStateManager) is responsible for pausing before calling this method

        guard FileManager.default.fileExists(atPath: url.path) else {
            throw NSError(domain: "EmulatorCore", code: 404, userInfo: [
                NSLocalizedDescriptionKey: "Save state file not found at path: \(url.path)"
            ])
        }

        // Validate emulator state - must be paused or running, not stopped
        guard self.state != .stopped else {
            throw NSError(domain: "EmulatorCore", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Cannot load state: emulator is stopped"
            ])
        }

        // Validate file is not empty
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let fileSize = attributes[.size] as? UInt64,
              fileSize > 0 else {
            throw NSError(domain: "EmulatorCore", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Save state file is empty or corrupted"
            ])
        }

        // Create save state object with proper protocol conformance
        let saveState = SaveStateManager.PersistentSaveState(
            fileURL: url,
            gameType: self.game.type,
            isSaved: true
        )

        // Load the save state using DeltaCore's load method
        // This will:
        // 1. Load the save state from file
        // 2. Update cheats to ensure they remain active
        // 3. Reset and reactivate controller inputs
        do {
            try self.load(saveState)
        } catch {
            throw NSError(domain: "EmulatorCore", code: 500, userInfo: [
                NSLocalizedDescriptionKey: "Failed to load save state: \(error.localizedDescription)",
                NSLocalizedFailureReasonErrorKey: error.localizedDescription
            ])
        }
    }
}
