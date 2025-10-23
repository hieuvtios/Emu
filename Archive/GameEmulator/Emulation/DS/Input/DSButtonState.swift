//
//  DSButtonState.swift
//  GameEmulator
//
//  Button state management for Nintendo DS controller
//

import Foundation
import DeltaCore
import MelonDSDeltaCore

enum DSButtonType: Int, CaseIterable, GameButtonType {
    // D-Pad
    case up = 0
    case down = 1
    case left = 2
    case right = 3

    // Face buttons
    case a = 4
    case b = 5
    case x = 6
    case y = 7

    // Shoulder buttons
    case l = 8
    case r = 9

    // System buttons
    case start = 10
    case select = 11

    var displayName: String {
        switch self {
        case .up: return "Up"
        case .down: return "Down"
        case .left: return "Left"
        case .right: return "Right"
        case .a: return "A"
        case .b: return "B"
        case .x: return "X"
        case .y: return "Y"
        case .l: return "L"
        case .r: return "R"
        case .start: return "Start"
        case .select: return "Select"
        }
    }

    var objcValue: Int {
        return self.rawValue
    }

    // Map to MelonDSGameInput enum values (matching MelonDSDeltaCore)
    var buttonMask: Int32 {
        switch self {
        case .a:      return 1      // MelonDSGameInput.a
        case .b:      return 2      // MelonDSGameInput.b
        case .select: return 4      // MelonDSGameInput.select
        case .start:  return 8      // MelonDSGameInput.start
        case .right:  return 16     // MelonDSGameInput.right
        case .left:   return 32     // MelonDSGameInput.left
        case .up:     return 64     // MelonDSGameInput.up
        case .down:   return 128    // MelonDSGameInput.down
        case .r:      return 256    // MelonDSGameInput.r
        case .l:      return 512    // MelonDSGameInput.l
        case .x:      return 1024   // MelonDSGameInput.x
        case .y:      return 2048   // MelonDSGameInput.y
        }
    }

    // Map to DeltaCore's MelonDSGameInput
    var gameInput: Input {
        switch self {
        case .a: return MelonDSGameInput.a
        case .b: return MelonDSGameInput.b
        case .select: return MelonDSGameInput.select
        case .start: return MelonDSGameInput.start
        case .right: return MelonDSGameInput.right
        case .left: return MelonDSGameInput.left
        case .up: return MelonDSGameInput.up
        case .down: return MelonDSGameInput.down
        case .r: return MelonDSGameInput.r
        case .l: return MelonDSGameInput.l
        case .x: return MelonDSGameInput.x
        case .y: return MelonDSGameInput.y
        }
    }

    // Create controller-type input for GameController protocol
    var controllerInput: Input {
        return DSControllerInput(button: self)
    }

    // GameButtonType protocol requirement
    static var dpadButtons: [DSButtonType] {
        return [.up, .down, .left, .right]
    }

    // Group buttons by type
    static var faceButtons: [DSButtonType] {
        return [.a, .b, .x, .y]
    }

    static var shoulderButtons: [DSButtonType] {
        return [.l, .r]
    }

    static var systemButtons: [DSButtonType] {
        return [.start, .select]
    }

    var isDPad: Bool {
        return Self.dpadButtons.contains(self)
    }

    var isFaceButton: Bool {
        return Self.faceButtons.contains(self)
    }

    var isShoulderButton: Bool {
        return Self.shoulderButtons.contains(self)
    }

    var isSystemButton: Bool {
        return Self.systemButtons.contains(self)
    }
}

// Controller-type input wrapper that matches .controllerSkin input type
struct DSControllerInput: Input {
    let button: DSButtonType

    var type: InputType {
        return .controller(.controllerSkin)
    }

    var stringValue: String {
        // Use the same format as MelonDSGameInput so mapping works
        return "ds.\(button.displayName.lowercased())"
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
        guard components.count == 2, components[0] == "ds" else { return nil }
        guard let button = DSButtonType.allCases.first(where: { $0.displayName.lowercased() == components[1] }) else { return nil }
        self.button = button
    }

    init(button: DSButtonType) {
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
        guard let buttonType = DSButtonType(rawValue: intValue) else { return nil }
        self.button = buttonType
    }
}

struct DSButtonStateTracker {
    private var pressedButtons: Set<DSButtonType> = []

    mutating func press(_ button: DSButtonType) -> Bool {
        return pressedButtons.insert(button).inserted
    }

    mutating func release(_ button: DSButtonType) -> Bool {
        return pressedButtons.remove(button) != nil
    }

    func isPressed(_ button: DSButtonType) -> Bool {
        return pressedButtons.contains(button)
    }

    mutating func reset() {
        pressedButtons.removeAll()
    }

    var allPressed: Set<DSButtonType> {
        return pressedButtons
    }
}
