//
//  GBAButtonState.swift
//  GameEmulator
//
//  Button state management for GBA controller
//

import Foundation
import DeltaCore
import GBADeltaCore

enum GBAButtonType: Int, CaseIterable, GameButtonType {
    case up = 0
    case down = 1
    case left = 2
    case right = 3
    case a = 4
    case b = 5
    case l = 6
    case r = 7
    case start = 8
    case select = 9

    var displayName: String {
        switch self {
        case .up: return "Up"
        case .down: return "Down"
        case .left: return "Left"
        case .right: return "Right"
        case .a: return "A"
        case .b: return "B"
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

    // Map to GBAGameInput enum values (matching GBADeltaCore)
    var buttonMask: Int32 {
        switch self {
        case .up:     return 64    // GBAGameInput.up
        case .down:   return 128   // GBAGameInput.down
        case .left:   return 32    // GBAGameInput.left
        case .right:  return 16    // GBAGameInput.right
        case .a:      return 1     // GBAGameInput.a
        case .b:      return 2     // GBAGameInput.b
        case .l:      return 512   // GBAGameInput.l
        case .r:      return 256   // GBAGameInput.r
        case .start:  return 8     // GBAGameInput.start
        case .select: return 4     // GBAGameInput.select
        }
    }

    // Map to DeltaCore's GBAGameInput
    var gameInput: Input {
        switch self {
        case .up: return GBAGameInput.up
        case .down: return GBAGameInput.down
        case .left: return GBAGameInput.left
        case .right: return GBAGameInput.right
        case .a: return GBAGameInput.a
        case .b: return GBAGameInput.b
        case .l: return GBAGameInput.l
        case .r: return GBAGameInput.r
        case .start: return GBAGameInput.start
        case .select: return GBAGameInput.select
        }
    }

    // Create controller-type input for GameController protocol
    var controllerInput: Input {
        return GBAControllerInput(button: self)
    }

    // GameButtonType protocol requirement
    static var dpadButtons: [GBAButtonType] {
        return [.up, .down, .left, .right]
    }
}

// Controller-type input wrapper that matches .controllerSkin input type
struct GBAControllerInput: Input {
    let button: GBAButtonType

    var type: InputType {
        return .controller(.controllerSkin)
    }

    var stringValue: String {
        // Use the same format as GBAGameInput so mapping works
        return "gba.\(button.displayName.lowercased())"
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
        guard components.count == 2, components[0] == "gba" else { return nil }
        guard let button = GBAButtonType.allCases.first(where: { $0.displayName.lowercased() == components[1] }) else { return nil }
        self.button = button
    }

    init(button: GBAButtonType) {
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
        guard let buttonType = GBAButtonType(rawValue: intValue) else { return nil }
        self.button = buttonType
    }
}

struct GBAButtonStateTracker {
    private var pressedButtons: Set<GBAButtonType> = []

    mutating func press(_ button: GBAButtonType) -> Bool {
        return pressedButtons.insert(button).inserted
    }

    mutating func release(_ button: GBAButtonType) -> Bool {
        return pressedButtons.remove(button) != nil
    }

    func isPressed(_ button: GBAButtonType) -> Bool {
        return pressedButtons.contains(button)
    }

    mutating func reset() {
        pressedButtons.removeAll()
    }

    var allPressed: Set<GBAButtonType> {
        return pressedButtons
    }
}
