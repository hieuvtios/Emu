//
//  SNESDirectController.swift
//  GameEmulator
//
//  Direct SNES controller using Snes9x bridge (no DeltaCore)
//

import UIKit

class SNESDirectController {

    // MARK: - Properties

    let name: String
    let playerIndex: Int
    private let inputBridge: SNESInputBridge

    // MARK: - Initialization

    init(name: String, playerIndex: Int = 0) {
        self.name = name
        self.playerIndex = playerIndex
        self.inputBridge = SNESInputBridge.shared()
    }

    deinit {
        self.reset()
    }

    // MARK: - Public Methods

    func pressButton(_ button: SNESButtonType) {
        inputBridge.pressButton(Int32(button.buttonMask), forPlayer: Int32(playerIndex))
    }

    func releaseButton(_ button: SNESButtonType) {
        inputBridge.releaseButton(Int32(button.buttonMask), forPlayer: Int32(playerIndex))
    }

    func pressDPadButtons(_ buttons: [SNESButtonType]) {
        for button in buttons {
            pressButton(button)
        }
    }

    func releaseAllDPadButtons() {
        for button in SNESButtonType.dpadButtons {
            releaseButton(button)
        }
    }

    func reset() {
        inputBridge.resetAllInputs()
    }
}
