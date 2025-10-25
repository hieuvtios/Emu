//
//  SNESButtonState.swift
//  GameEmulator
//
//  Button state management for SNES controller
//

import Foundation
import DeltaCore
import SNESDeltaCore

enum SNESButtonType: Int, CaseIterable, GameButtonType {
    case up = 0
    case down = 1
    case left = 2
    case right = 3
    case a = 4
    case b = 5
    case x = 6
    case y = 7
    case l = 8
    case r = 9
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

    // Convert to Objective-C enum
    var objcValue: Int {
        return self.rawValue
    }

    // Map to SNESGameInput enum values (matching SNESDeltaCore)
    var buttonMask: Int32 {
        switch self {
        case .up:     return 1      // SNESGameInput.up
        case .down:   return 2      // SNESGameInput.down
        case .left:   return 4      // SNESGameInput.left
        case .right:  return 8      // SNESGameInput.right
        case .a:      return 16     // SNESGameInput.a
        case .b:      return 32     // SNESGameInput.b
        case .x:      return 64     // SNESGameInput.x
        case .y:      return 128    // SNESGameInput.y
        case .l:      return 256    // SNESGameInput.l
        case .r:      return 512    // SNESGameInput.r
        case .start:  return 1024   // SNESGameInput.start
        case .select: return 2048   // SNESGameInput.select
        }
    }

    // Map to DeltaCore's SNESGameInput
    var gameInput: Input {
        switch self {
        case .up: return SNESGameInput.up
        case .down: return SNESGameInput.down
        case .left: return SNESGameInput.left
        case .right: return SNESGameInput.right
        case .a: return SNESGameInput.a
        case .b: return SNESGameInput.b
        case .x: return SNESGameInput.x
        case .y: return SNESGameInput.y
        case .l: return SNESGameInput.l
        case .r: return SNESGameInput.r
        case .start: return SNESGameInput.start
        case .select: return SNESGameInput.select
        }
    }

    // Create controller-type input for GameController protocol
    var controllerInput: Input {
        return SNESControllerInput(button: self)
    }

    // GameButtonType protocol requirement
    static var dpadButtons: [SNESButtonType] {
        return [.up, .down, .left, .right]
    }
}

// Controller-type input wrapper that matches .controllerSkin input type
struct SNESControllerInput: Input {
    let button: SNESButtonType

    var type: InputType {
        return .controller(.controllerSkin)
    }

    var stringValue: String {
        // Use the same format as SNESGameInput so mapping works
        return "snes.\(button.displayName.lowercased())"
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
        guard components.count == 2, components[0] == "snes" else { return nil }
        guard let button = SNESButtonType.allCases.first(where: { $0.displayName.lowercased() == components[1] }) else { return nil }
        self.button = button
    }

    init(button: SNESButtonType) {
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
        guard let buttonType = SNESButtonType(rawValue: intValue) else { return nil }
        self.button = buttonType
    }
}

struct SNESButtonStateTracker {
    private var pressedButtons: Set<SNESButtonType> = []

    mutating func press(_ button: SNESButtonType) -> Bool {
        return pressedButtons.insert(button).inserted
    }

    mutating func release(_ button: SNESButtonType) -> Bool {
        return pressedButtons.remove(button) != nil
    }

    func isPressed(_ button: SNESButtonType) -> Bool {
        return pressedButtons.contains(button)
    }

    mutating func reset() {
        pressedButtons.removeAll()
    }

    var allPressed: Set<SNESButtonType> {
        return pressedButtons
    }
}
