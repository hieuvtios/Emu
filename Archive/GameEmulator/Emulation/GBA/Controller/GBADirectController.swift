//
//  GBADirectController.swift
//  GameEmulator
//
//  Direct GBA controller using mGBA bridge (no DeltaCore)
//

import UIKit

class GBADirectController {

    // MARK: - Properties

    let name: String
    let playerIndex: Int
    private let inputBridge: GBAInputBridge

    // MARK: - Initialization

    init(name: String, playerIndex: Int = 0) {
        self.name = name
        self.playerIndex = playerIndex
        self.inputBridge = GBAInputBridge.shared()
    }

    deinit {
        self.reset()
    }

    // MARK: - Public Methods

    func pressButton(_ button: GBAButtonType) {
        inputBridge.pressButton(Int32(button.buttonMask), forPlayer: Int32(playerIndex))
    }

    func releaseButton(_ button: GBAButtonType) {
        inputBridge.releaseButton(Int32(button.buttonMask), forPlayer: Int32(playerIndex))
    }

    func pressDPadButtons(_ buttons: [GBAButtonType]) {
        for button in buttons {
            pressButton(button)
        }
    }

    func releaseAllDPadButtons() {
        for button in GBAButtonType.dpadButtons {
            releaseButton(button)
        }
    }

    func reset() {
        inputBridge.resetAllInputs()
    }
}
