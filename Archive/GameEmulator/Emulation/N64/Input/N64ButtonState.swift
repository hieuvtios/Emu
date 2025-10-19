//
//  N64ButtonState.swift
//  GameEmulator
//
//  Button state management for N64 controller
//

import Foundation
import DeltaCore
import N64DeltaCore

enum N64ButtonType: Int, CaseIterable, GameButtonType {
    case up = 0
    case down = 1
    case left = 2
    case right = 3
    case a = 4
    case b = 5
    case cUp = 6
    case cDown = 7
    case cLeft = 8
    case cRight = 9
    case l = 10
    case r = 11
    case z = 12
    case start = 13

    var displayName: String {
        switch self {
        case .up: return "Up"
        case .down: return "Down"
        case .left: return "Left"
        case .right: return "Right"
        case .a: return "A"
        case .b: return "B"
        case .cUp: return "C↑"
        case .cDown: return "C↓"
        case .cLeft: return "C←"
        case .cRight: return "C→"
        case .l: return "L"
        case .r: return "R"
        case .z: return "Z"
        case .start: return "Start"
        }
    }

    // Map to DeltaCore's N64GameInput
    var gameInput: Input {
        switch self {
        case .up: return N64GameInput.up
        case .down: return N64GameInput.down
        case .left: return N64GameInput.left
        case .right: return N64GameInput.right
        case .a: return N64GameInput.a
        case .b: return N64GameInput.b
        case .cUp: return N64GameInput.cUp
        case .cDown: return N64GameInput.cDown
        case .cLeft: return N64GameInput.cLeft
        case .cRight: return N64GameInput.cRight
        case .l: return N64GameInput.l
        case .r: return N64GameInput.r
        case .z: return N64GameInput.z
        case .start: return N64GameInput.start
        }
    }

    // Create controller-type input for GameController protocol
    var controllerInput: Input {
        return N64ControllerInput(button: self)
    }

    // GameButtonType protocol requirement
    var isDPad: Bool {
        return Self.dpadButtons.contains(self)
    }

    // GameButtonType protocol requirement
    static var dpadButtons: [N64ButtonType] {
        return [.up, .down, .left, .right]
    }

    // C-button cluster (specific to N64)
    static var cButtons: [N64ButtonType] {
        return [.cUp, .cDown, .cLeft, .cRight]
    }
}

// Controller-type input wrapper that matches .controllerSkin input type
struct N64ControllerInput: Input {
    let button: N64ButtonType

    var type: InputType {
        return .controller(.controllerSkin)
    }

    var stringValue: String {
        // Use the same format as N64GameInput so mapping works
        return "n64.\(button.displayName.lowercased())"
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
        guard components.count == 2, components[0] == "n64" else { return nil }
        guard let button = N64ButtonType.allCases.first(where: { $0.displayName.lowercased() == components[1] }) else { return nil }
        self.button = button
    }

    init(button: N64ButtonType) {
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
        guard let buttonType = N64ButtonType(rawValue: intValue) else { return nil }
        self.button = buttonType
    }
}

struct N64ButtonStateTracker {
    private var pressedButtons: Set<N64ButtonType> = []

    mutating func press(_ button: N64ButtonType) -> Bool {
        return pressedButtons.insert(button).inserted
    }

    mutating func release(_ button: N64ButtonType) -> Bool {
        return pressedButtons.remove(button) != nil
    }

    func isPressed(_ button: N64ButtonType) -> Bool {
        return pressedButtons.contains(button)
    }

    mutating func reset() {
        pressedButtons.removeAll()
    }

    var allPressed: Set<N64ButtonType> {
        return pressedButtons
    }
}
