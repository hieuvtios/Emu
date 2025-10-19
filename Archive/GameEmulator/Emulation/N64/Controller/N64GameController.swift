//
//  N64GameController.swift
//  GameEmulator
//
//  Custom N64 controller using N64DeltaCore bridge
//

import UIKit
import DeltaCore
import N64DeltaCore

typealias N64GameController = GenericGameController<N64ButtonType>

// MARK: - N64-specific extensions

extension N64GameController {

    /// Convenience method for pressing multiple C-buttons at once
    func pressCButtons(_ buttons: [N64ButtonType]) {
        for button in buttons {
            self.pressButton(button)
        }
    }

    /// Convenience method for releasing all C-buttons
    func releaseAllCButtons() {
        for button in N64ButtonType.cButtons {
            self.releaseButton(button)
        }
    }
}
