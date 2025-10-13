//
//  NESControllerLayout.swift
//  GameEmulator
//
//  Layout definitions for NES controller
//

import SwiftUI

struct NESControllerLayout {

    // MARK: - Layout Constants

    enum LayoutMode {
        case landscape
        case portrait
    }

    struct ButtonLayout {
        let position: CGPoint
        let size: CGSize
        let button: NESButtonType
    }

    struct DPadLayout {
        let center: CGPoint
        let radius: CGFloat
    }

    // MARK: - Landscape Layout

    static func landscapeLayout(screenSize: CGSize) -> NESControllerLayoutDefinition {
        let baseWidth: CGFloat = 852
        let baseHeight: CGFloat = 393

        let widthRatio = screenSize.width / baseWidth
        let heightRatio = screenSize.height / baseHeight

        let buttonSize = CGSize(width: 55 * heightRatio, height: 55 * heightRatio)
        let dpadRadius: CGFloat = 60 * heightRatio
        let smallButtonSize = CGSize(width: 45 * heightRatio, height: 20 * heightRatio)

        // D-Pad (bottom-left corner)
        let dpadCenter = CGPoint(
            x: screenSize.width * 0.2,
            y: screenSize.height * 0.75
        )

        // Action buttons (right side, stacked vertically with slight offset)
        // A button - top right
        // B button - below and slightly left of A
        let actionButtonsBaseX = screenSize.width * 0.95
        let actionButtonsBaseY = screenSize.height * 0.68
        let verticalSpacing: CGFloat = 70 * heightRatio

        let actionButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsBaseX,
                    y: actionButtonsBaseY
                ),
                size: buttonSize,
                button: .a
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsBaseX - 50 * widthRatio,
                    y: actionButtonsBaseY + verticalSpacing
                ),
                size: buttonSize,
                button: .b
            )
        ]

        // Center Buttons (Select/Start) - positioned below the screen area
        let centerButtonsY = screenSize.height * 0.90

        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 ,
                    y: centerButtonsY
                ),
                size: smallButtonSize,
                button: .select
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 80,
                    y: centerButtonsY
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return NESControllerLayoutDefinition(
            mode: .landscape,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            centerButtons: centerButtons
        )
    }

    // MARK: - Portrait Layout

    static func portraitLayout(screenSize: CGSize) -> NESControllerLayoutDefinition {
        // iPhone 17 reference
        let baseWidth: CGFloat = 393
        let baseHeight: CGFloat = 852
        
        let widthRatio = screenSize.width / baseWidth
        let heightRatio = screenSize.height / baseHeight
        
        // Scaled constants
        let buttonSize = CGSize(width: 55 * widthRatio, height: 55 * widthRatio)
        let dpadRadius: CGFloat = 60 * widthRatio
        let smallButtonSize = CGSize(width: 45 * widthRatio, height: 20 * heightRatio)
        
        // Controls area (same relative position)
        let controlsY = screenSize.height * 0.72 * heightRatio
        
        // D-Pad (bottom-left)
        let dpadCenter = CGPoint(
            x: 95 * widthRatio,
            y: controlsY + (110 * heightRatio)
        )
        
        // Action buttons (bottom-right)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - (95 * widthRatio),
            y: controlsY + (110 * heightRatio)
        )
        
        let diagonalOffset: CGFloat = 28 * widthRatio
        
        let actionButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - diagonalOffset,
                    y: actionButtonsCenter.y - diagonalOffset
                ),
                size: buttonSize,
                button: .b
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + diagonalOffset,
                    y: actionButtonsCenter.y + diagonalOffset
                ),
                size: buttonSize,
                button: .a
            )
        ]
        
        // Start/Select (centered above bottom edge)
        let centerButtonsY = screenSize.height - (70 * heightRatio)

        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 - (40 * widthRatio),
                    y: centerButtonsY + (100 * heightRatio)
                ),
                size: smallButtonSize,
                button: .select
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + (40 * widthRatio),
                    y: centerButtonsY + (100 * heightRatio)
                ),
                size: smallButtonSize,
                button: .start
            )
        ]
        
        return NESControllerLayoutDefinition(
            mode: .portrait,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            centerButtons: centerButtons
        )
    }
}

struct NESControllerLayoutDefinition {
    let mode: NESControllerLayout.LayoutMode
    let dpad: NESControllerLayout.DPadLayout
    let actionButtons: [NESControllerLayout.ButtonLayout]
    let centerButtons: [NESControllerLayout.ButtonLayout]
}
