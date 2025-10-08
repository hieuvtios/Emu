//
//  GenesisButtonState.swift
//  GameEmulator
//
//  Button state management for Genesis controller
//

import Foundation
import DeltaCore
import GPGXDeltaCore

enum GenesisButtonType: Int, CaseIterable, GameButtonType {
    case up = 0
    case down = 1
    case left = 2
    case right = 3
    case a = 4
    case b = 5
    case c = 6
    case start = 7
    case x = 8
    case y = 9
    case z = 10
    case mode = 11

    var displayName: String {
        switch self {
        case .up: return "Up"
        case .down: return "Down"
        case .left: return "Left"
        case .right: return "Right"
        case .a: return "A"
        case .b: return "B"
        case .c: return "C"
        case .start: return "Start"
        case .x: return "X"
        case .y: return "Y"
        case .z: return "Z"
        case .mode: return "Mode"
        }
    }

    // Convert to Objective-C enum
    var objcValue: Int {
        return self.rawValue
    }

    // Map to DeltaCore's GPGXGameInput
    var gameInput: Input {
        switch self {
        case .up: return GPGXGameInput.up
        case .down: return GPGXGameInput.down
        case .left: return GPGXGameInput.left
        case .right: return GPGXGameInput.right
        case .a: return GPGXGameInput.a
        case .b: return GPGXGameInput.b
        case .c: return GPGXGameInput.c
        case .start: return GPGXGameInput.start
        case .x: return GPGXGameInput.x
        case .y: return GPGXGameInput.y
        case .z: return GPGXGameInput.z
        case .mode: return GPGXGameInput.mode
        }
    }

    // Create controller-type input for GameController protocol
    var controllerInput: Input {
        return GenesisControllerInput(button: self)
    }

    // GameButtonType protocol requirement
    static var dpadButtons: [GenesisButtonType] {
        return [.up, .down, .left, .right]
    }

    // Direct bridge button mask values (matching GPGXGameInput raw values)
    var buttonMask: Int {
        switch self {
        case .up: return 0x01
        case .down: return 0x02
        case .left: return 0x04
        case .right: return 0x08
        case .a: return 0x40
        case .b: return 0x10
        case .c: return 0x20
        case .start: return 0x080
        case .x: return 0x400
        case .y: return 0x200
        case .z: return 0x100
        case .mode: return 0x800
        }
    }
}

// Controller-type input wrapper that matches .controllerSkin input type
struct GenesisControllerInput: Input {
    let button: GenesisButtonType

    var type: InputType {
        return .controller(.controllerSkin)
    }

    var stringValue: String {
        // Use the same format as GPGXGameInput so mapping works
        return "genesis.\(button.displayName.lowercased())"
    }

    var isContinuous: Bool {
        return false
    }

    // MARK: - RawRepresentable

    var rawValue: String {
        return stringValue
    }

    init?(rawValue: String) {
        let components = rawValue.components(separatedBy: ".")
        guard components.count == 2, components[0] == "genesis" else { return nil }
        guard let button = GenesisButtonType.allCases.first(where: { $0.displayName.lowercased() == components[1] }) else { return nil }
        self.button = button
    }

    init(button: GenesisButtonType) {
        self.button = button
    }

    // MARK: - CodingKey

    var intValue: Int? {
        return button.rawValue
    }

    init?(stringValue: String) {
        self.init(rawValue: stringValue)
    }

    init?(intValue: Int) {
        guard let buttonType = GenesisButtonType(rawValue: intValue) else { return nil }
        self.button = buttonType
    }
}

struct GenesisButtonStateTracker {
    private var pressedButtons: Set<GenesisButtonType> = []

    mutating func press(_ button: GenesisButtonType) -> Bool {
        return pressedButtons.insert(button).inserted
    }

    mutating func release(_ button: GenesisButtonType) -> Bool {
        return pressedButtons.remove(button) != nil
    }

    func isPressed(_ button: GenesisButtonType) -> Bool {
        return pressedButtons.contains(button)
    }

    mutating func reset() {
        pressedButtons.removeAll()
    }

    var allPressed: Set<GenesisButtonType> {
        return pressedButtons
    }
}
