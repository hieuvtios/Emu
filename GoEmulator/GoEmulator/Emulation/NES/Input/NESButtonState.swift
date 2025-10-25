//
//  NESButtonState.swift
//  GameEmulator
//
//  Button state management for NES controller
//

import Foundation
import DeltaCore
import NESDeltaCore

enum NESButtonType: Int, CaseIterable, GameButtonType {
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

    // Map to DeltaCore's NESGameInput
    var gameInput: Input {
        switch self {
        case .up: return NESGameInput.up
        case .down: return NESGameInput.down
        case .left: return NESGameInput.left
        case .right: return NESGameInput.right
        case .a: return NESGameInput.a
        case .b: return NESGameInput.b
        case .start: return NESGameInput.start
        case .select: return NESGameInput.select
        }
    }

    // Create controller-type input for GameController protocol
    var controllerInput: Input {
        return NESControllerInput(button: self)
    }

    // GameButtonType protocol requirement
    static var dpadButtons: [NESButtonType] {
        return [.up, .down, .left, .right]
    }
}

// Controller-type input wrapper that matches .controllerSkin input type
struct NESControllerInput: Input {
    let button: NESButtonType

    var type: InputType {
        return .controller(.controllerSkin)
    }

    var stringValue: String {
        // Use the same format as NESGameInput so mapping works
        return "nes.\(button.displayName.lowercased())"
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
        guard components.count == 2, components[0] == "nes" else { return nil }
        guard let button = NESButtonType.allCases.first(where: { $0.displayName.lowercased() == components[1] }) else { return nil }
        self.button = button
    }

    init(button: NESButtonType) {
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
        guard let buttonType = NESButtonType(rawValue: intValue) else { return nil }
        self.button = buttonType
    }
}

struct NESButtonStateTracker {
    private var pressedButtons: Set<NESButtonType> = []

    mutating func press(_ button: NESButtonType) -> Bool {
        return pressedButtons.insert(button).inserted
    }

    mutating func release(_ button: NESButtonType) -> Bool {
        return pressedButtons.remove(button) != nil
    }

    func isPressed(_ button: NESButtonType) -> Bool {
        return pressedButtons.contains(button)
    }

    mutating func reset() {
        pressedButtons.removeAll()
    }

    var allPressed: Set<NESButtonType> {
        return pressedButtons
    }
}
