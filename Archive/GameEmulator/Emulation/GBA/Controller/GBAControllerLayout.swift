//
//  GBAControllerLayout.swift
//  GameEmulator
//
//  Layout definitions for GBA controller (Game Boy Advance style)
//

import SwiftUI

struct GBAControllerLayout {

    // MARK: - Layout Constants

    enum LayoutMode {
        case landscape
        case portrait
    }

    struct ButtonLayout {
        let position: CGPoint
        let size: CGSize
        let button: GBAButtonType
    }

    struct DPadLayout {
        let center: CGPoint
        let radius: CGFloat
    }

    // MARK: - Landscape Layout

    static func landscapeLayout(screenSize: CGSize) -> GBAControllerLayoutDefinition {
        let padding: CGFloat = 40
        let buttonSize = CGSize(width: 60, height: 60)
        let dpadRadius: CGFloat = 80
        let smallButtonSize = CGSize(width: 50, height: 25)

        // D-Pad (left side)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: screenSize.height / 2
        )

        // Action buttons (right side) - GBA horizontal layout
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - 90,
            y: screenSize.height / 2
        )

        let actionButtonSpacing: CGFloat = 55

        let actionButtons: [ButtonLayout] = [
            // B (left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonSpacing,
                    y: actionButtonsCenter.y + 20
                ),
                size: buttonSize,
                button: .b
            ),
            // A (right, slightly higher - authentic GBA layout)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Shoulder buttons (top)
        let shoulderButtons: [ButtonLayout] = [
            // L
            ButtonLayout(
                position: CGPoint(x: padding + 60, y: 30),
                size: CGSize(width: 80, height: 35),
                button: .l
            ),
            // R
            ButtonLayout(
                position: CGPoint(x: screenSize.width - padding - 140, y: 30),
                size: CGSize(width: 80, height: 35),
                button: .r
            )
        ]

        // Start/Select (center, angled like GBA)
        let centerButtons: [ButtonLayout] = [
            // Select
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 - 40,
                    y: screenSize.height - 70
                ),
                size: smallButtonSize,
                button: .select
            ),
            // Start
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 10,
                    y: screenSize.height - 70
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return GBAControllerLayoutDefinition(
            mode: .landscape,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            shoulderButtons: shoulderButtons,
            centerButtons: centerButtons
        )
    }

    // MARK: - Portrait Layout

    static func portraitLayout(screenSize: CGSize) -> GBAControllerLayoutDefinition {
        let padding: CGFloat = 30
        let buttonSize = CGSize(width: 55, height: 55)
        let dpadRadius: CGFloat = 70
        let smallButtonSize = CGSize(width: 45, height: 22)

        let controlsY = screenSize.height * 0.65

        // D-Pad (lower left)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: controlsY
        )

        // Action buttons (lower right) - GBA horizontal layout
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - 80,
            y: controlsY
        )

        let actionButtonSpacing: CGFloat = 50

        let actionButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonSpacing,
                    y: actionButtonsCenter.y + 15
                ),
                size: buttonSize,
                button: .b
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Shoulder buttons
        let shoulderButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(x: padding + 50, y: controlsY - 120),
                size: CGSize(width: 70, height: 30),
                button: .l
            ),
            ButtonLayout(
                position: CGPoint(x: screenSize.width - padding - 120, y: controlsY - 120),
                size: CGSize(width: 70, height: 30),
                button: .r
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

        return GBAControllerLayoutDefinition(
            mode: .portrait,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            shoulderButtons: shoulderButtons,
            centerButtons: centerButtons
        )
    }
}

struct GBAControllerLayoutDefinition {
    let mode: GBAControllerLayout.LayoutMode
    let dpad: GBAControllerLayout.DPadLayout
    let actionButtons: [GBAControllerLayout.ButtonLayout]
    let shoulderButtons: [GBAControllerLayout.ButtonLayout]
    let centerButtons: [GBAControllerLayout.ButtonLayout]
}
