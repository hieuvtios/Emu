//
//  GBCControllerLayout.swift
//  GameEmulator
//
//  Layout definitions for GBC controller
//

import SwiftUI

struct GBCControllerLayout {

    // MARK: - Layout Constants

    enum LayoutMode {
        case landscape
        case portrait
    }

    struct ButtonLayout {
        let position: CGPoint
        let size: CGSize
        let button: GBCButtonType
    }

    struct DPadLayout {
        let center: CGPoint
        let radius: CGFloat
    }

    // MARK: - Landscape Layout

    static func landscapeLayout(screenSize: CGSize) -> GBCControllerLayoutDefinition {
        let padding: CGFloat = 40
        let buttonSize = CGSize(width: 68, height: 68)
        let dpadRadius: CGFloat = 80
        let smallButtonSize = CGSize(width: 50, height: 25)

        // D-Pad (left side)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: screenSize.height / 2
        )

        // Action buttons (right side) - Simple two button layout (B on left, A on right)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius,
            y: screenSize.height / 2
        )

        let actionButtonOffset: CGFloat = 45

        let actionButtons: [ButtonLayout] = [
            // B (left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .b
            ),
            // A (right)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Start/Select (center bottom)
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
            ,
            ButtonLayout(
                position: CGPoint(
                    x: 20,
                    y: screenSize.height - 90
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return GBCControllerLayoutDefinition(
            mode: .landscape,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            centerButtons: centerButtons
        )
    }

    // MARK: - Portrait Layout

    static func portraitLayout(screenSize: CGSize) -> GBCControllerLayoutDefinition {
        let padding: CGFloat = 30
        let buttonSize = CGSize(width: 68, height: 68)
        let dpadRadius: CGFloat = 70
        let smallButtonSize = CGSize(width: 45, height: 22)

        let controlsY = screenSize.height * 0.65

        // D-Pad (lower left)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: controlsY
        )

        // Action buttons (lower right)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius,
            y: controlsY
        )

        let actionButtonOffset: CGFloat = 40

        let actionButtons: [ButtonLayout] = [
            // B (left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .b
            ),
            // A (right)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Start/Select
        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 - 55,
                    y: screenSize.height - 90
                ),
                size: smallButtonSize,
                button: .select
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 10,
                    y: screenSize.height - 90
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return GBCControllerLayoutDefinition(
            mode: .portrait,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            centerButtons: centerButtons
        )
    }
}

struct GBCControllerLayoutDefinition {
    let mode: GBCControllerLayout.LayoutMode
    let dpad: GBCControllerLayout.DPadLayout
    let actionButtons: [GBCControllerLayout.ButtonLayout]
    let centerButtons: [GBCControllerLayout.ButtonLayout]
}
