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

    // MARK: - Analog Stick Control

    /// Update analog stick position with continuous X/Y values
    /// - Parameters:
    ///   - x: Horizontal position from -1.0 (left) to 1.0 (right)
    ///   - y: Vertical position from -1.0 (up) to 1.0 (down)
    func updateAnalogStick(x: CGFloat, y: CGFloat) {
        // Threshold for activating directional inputs (30% of full range)
        let activationThreshold: CGFloat = 0.3

        // Release all analog stick inputs first
        releaseAllAnalogStickButtons()

        // Activate horizontal inputs based on X position
        if x < -activationThreshold {
            // Moving left
            let intensity = min(abs(x), 1.0)
            self.activate(N64ButtonType.analogStickLeft.controllerInput, value: Double(intensity))
        } else if x > activationThreshold {
            // Moving right
            let intensity = min(abs(x), 1.0)
            self.activate(N64ButtonType.analogStickRight.controllerInput, value: Double(intensity))
        }

        // Activate vertical inputs based on Y position
        if y < -activationThreshold {
            // Moving up (negative Y)
            let intensity = min(abs(y), 1.0)
            self.activate(N64ButtonType.analogStickUp.controllerInput, value: Double(intensity))
        } else if y > activationThreshold {
            // Moving down (positive Y)
            let intensity = min(abs(y), 1.0)
            self.activate(N64ButtonType.analogStickDown.controllerInput, value: Double(intensity))
        }
    }

    /// Release all analog stick inputs (return stick to center)
    func releaseAllAnalogStickButtons() {
        for button in N64ButtonType.analogStickButtons {
            self.deactivate(button.controllerInput)
        }
    }
}
