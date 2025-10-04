//
//  GBCButtonState.swift
//  GameEmulator
//
//  Button state management for GBC controller
//

import Foundation
import DeltaCore
import GBCDeltaCore

enum GBCButtonType: Int, CaseIterable, GameButtonType {
    case up = 0
    case down = 1
    case left = 2
    case right = 3
    case a = 4
    case b = 5
    case start = 6
    case select = 7

    var displayName: String {
        switch self {
        case .up: return "Up"
        case .down: return "Down"
        case .left: return "Left"
        case .right: return "Right"
        case .a: return "A"
        case .b: return "B"
        case .start: return "Start"
        case .select: return "Select"
        }
    }

    // Convert to Objective-C enum
    var objcValue: Int {
        return self.rawValue
    }

    // Map to GBCGameInput enum values (matching GBCDeltaCore)
    var buttonMask: Int32 {
        switch self {
        case .up:     return 0x40   // GBCGameInput.up
        case .down:   return 0x80   // GBCGameInput.down
        case .left:   return 0x20   // GBCGameInput.left
        case .right:  return 0x10   // GBCGameInput.right
        case .a:      return 0x01   // GBCGameInput.a
        case .b:      return 0x02   // GBCGameInput.b
        case .start:  return 0x08   // GBCGameInput.start
        case .select: return 0x04   // GBCGameInput.select
        }
    }

    // Map to DeltaCore's GBCGameInput
    var gameInput: Input {
        switch self {
        case .up: return GBCGameInput.up
        case .down: return GBCGameInput.down
        case .left: return GBCGameInput.left
        case .right: return GBCGameInput.right
        case .a: return GBCGameInput.a
        case .b: return GBCGameInput.b
        case .start: return GBCGameInput.start
        case .select: return GBCGameInput.select
        }
    }

    // Create controller-type input for GameController protocol
    var controllerInput: Input {
        return GBCControllerInput(button: self)
    }

    // GameButtonType protocol requirement
    static var dpadButtons: [GBCButtonType] {
        return [.up, .down, .left, .right]
    }
}

// Controller-type input wrapper that matches .controllerSkin input type
struct GBCControllerInput: Input {
    let button: GBCButtonType

    var type: InputType {
        return .controller(.controllerSkin)
    }

    var stringValue: String {
        // Use the same format as GBCGameInput so mapping works
        return "gbc.\(button.displayName.lowercased())"
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
        guard components.count == 2, components[0] == "gbc" else { return nil }
        guard let button = GBCButtonType.allCases.first(where: { $0.displayName.lowercased() == components[1] }) else { return nil }
        self.button = button
    }

    init(button: GBCButtonType) {
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
        guard let buttonType = GBCButtonType(rawValue: intValue) else { return nil }
        self.button = buttonType
    }
}

struct GBCButtonStateTracker {
    private var pressedButtons: Set<GBCButtonType> = []

    mutating func press(_ button: GBCButtonType) -> Bool {
        return pressedButtons.insert(button).inserted
    }

    mutating func release(_ button: GBCButtonType) -> Bool {
        return pressedButtons.remove(button) != nil
    }

    func isPressed(_ button: GBCButtonType) -> Bool {
        return pressedButtons.contains(button)
    }

    mutating func reset() {
        pressedButtons.removeAll()
    }

    var allPressed: Set<GBCButtonType> {
        return pressedButtons
    }
}
