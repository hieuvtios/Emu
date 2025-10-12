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
        let padding: CGFloat = 40
        let buttonSize = CGSize(width: 60, height: 60)
        let dpadRadius: CGFloat = 80
        let smallButtonSize = CGSize(width: 50, height: 25)

        // D-Pad (left side)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: screenSize.height / 2
        )

        // Action buttons (right side) - NES has simple horizontal A/B layout
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius,
            y: screenSize.height / 2
        )

        let actionButtonSpacing: CGFloat = 75

        let actionButtons: [ButtonLayout] = [
            // B (left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonSpacing / 2,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .b
            ),
            // A (right)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + actionButtonSpacing / 2,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Start/Select (center-bottom)
        let centerButtons: [ButtonLayout] = [
            // Select
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 - 60,
                    y: screenSize.height - 90
                ),
                size: smallButtonSize,
                button: .select
            ),
            // Start
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 10,
                    y: screenSize.height - 90
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
        let centerButtonsY = screenSize.height * 0.90
        let centerSpacing = 80 * widthRatio

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
