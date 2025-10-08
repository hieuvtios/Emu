//
//  GenericGameController.swift
//  GameEmulator
//
//  Generic game controller architecture for all emulator systems
//

import UIKit
import DeltaCore

// MARK: - GameButtonType Protocol

protocol GameButtonType: CaseIterable, RawRepresentable where RawValue == Int {
    var displayName: String { get }
    var gameInput: Input { get }
    var controllerInput: Input { get }
    var isDPad: Bool { get }

    static var dpadButtons: [Self] { get }
}

extension GameButtonType {
    var isDPad: Bool {
        return Self.dpadButtons.contains(where: { $0.rawValue == self.rawValue })
    }
}

// MARK: - Generic Game Controller

class GenericGameController<ButtonType: GameButtonType>: NSObject, GameController {

    // MARK: - GameController Protocol

    var name: String {
        return controllerName
    }

    var playerIndex: Int?

    let inputType: GameControllerInputType = .controllerSkin

    var defaultInputMapping: GameControllerInputMappingProtocol? {
        return GenericControllerInputMapping(controller: self)
    }

    // MARK: - Properties

    private let controllerName: String
    private let systemPrefix: String

    // MARK: - Initialization

    init(name: String, systemPrefix: String, playerIndex: Int? = 0) {
        self.controllerName = name
        self.systemPrefix = systemPrefix
        self.playerIndex = playerIndex
        super.init()
    }

    deinit {
        self.reset()
    }

    // MARK: - Public Methods

    func pressButton(_ button: ButtonType) {
        self.activate(button.controllerInput, value: 1.0)
    }

    func releaseButton(_ button: ButtonType) {
        self.deactivate(button.controllerInput)
    }

    func pressDPadButtons(_ buttons: [ButtonType]) {
        for button in buttons {
            self.activate(button.controllerInput, value: 1.0)
        }
    }

    func releaseAllDPadButtons() {
        for button in ButtonType.dpadButtons {
            self.deactivate(button.controllerInput)
        }
    }

    func reset() {
        for button in ButtonType.allCases {
            self.deactivate(button.controllerInput)
        }
    }
}

// MARK: - Generic Input Mapping

struct GenericControllerInputMapping<ButtonType: GameButtonType>: GameControllerInputMappingProtocol {
    let controller: GenericGameController<ButtonType>

    var name: String {
        return controller.name
    }

    var gameControllerInputType: GameControllerInputType {
        return controller.inputType
    }

    func input(forControllerInput controllerInput: Input) -> Input? {
        guard controllerInput.type == .controller(.controllerSkin) else {
            return nil
        }

        // Find matching button by string value
        let inputString = controllerInput.stringValue

        // Try to find button that matches this input
        for button in ButtonType.allCases {
            if button.controllerInput.stringValue == inputString {
                return button.gameInput
            }
        }

        return nil
    }
}
