//
//  DSGameController.swift
//  GameEmulator
//
//  Direct DS controller using MelonDS bridge (no DeltaCore)
//

import UIKit

class DSGameController {

    // MARK: - Properties

    let name: String
    let playerIndex: Int
    private let inputBridge: DSInputBridge

    // MARK: - Initialization

    init(name: String, playerIndex: Int = 0) {
        self.name = name
        self.playerIndex = playerIndex
        self.inputBridge = DSInputBridge.shared()
    }

    deinit {
        self.reset()
    }

    // MARK: - Public Methods

    func pressButton(_ button: DSButtonType) {
        inputBridge.pressButton(Int32(button.buttonMask), forPlayer: Int32(playerIndex))
    }

    func releaseButton(_ button: DSButtonType) {
        inputBridge.releaseButton(Int32(button.buttonMask), forPlayer: Int32(playerIndex))
    }

    func pressDPadButtons(_ buttons: [DSButtonType]) {
        for button in buttons {
            pressButton(button)
        }
    }

    func releaseAllDPadButtons() {
        for button in DSButtonType.dpadButtons {
            releaseButton(button)
        }
    }

    func reset() {
        inputBridge.resetAllInputs()
    }
}
