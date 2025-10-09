//
//  DSControllerLayout.swift
//  GameEmulator
//
//  Layout definitions for Nintendo DS controller
//  Unique dual-screen layout with portrait-style controls
//

import SwiftUI

struct DSControllerLayout {

    // MARK: - Layout Constants

    enum LayoutMode {
        case landscape
        case portrait
    }

    struct ButtonLayout {
        let position: CGPoint
        let size: CGSize
        let button: DSButtonType
    }

    struct DPadLayout {
        let center: CGPoint
        let radius: CGFloat
    }

    struct TouchScreenLayout {
        let frame: CGRect
        let isTop: Bool  // DS has dual screens
    }

    // MARK: - Landscape Layout

    static func landscapeLayout(screenSize: CGSize) -> DSControllerLayoutDefinition {
        let padding: CGFloat = 35
        let buttonSize = CGSize(width: 58, height: 58)
        let dpadRadius: CGFloat = 75
        let smallButtonSize = CGSize(width: 48, height: 24)
        let shoulderButtonSize = CGSize(width: 65, height: 30)

        // D-Pad (left side)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: screenSize.height / 2 + 20
        )

        // Face buttons (right side) - DS diamond layout like SNES
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius,
            y: screenSize.height / 2 + 20
        )

        let actionButtonOffset: CGFloat = 38

        let actionButtons: [ButtonLayout] = [
            // Y (left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .y
            ),
            // X (top)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y - actionButtonOffset
                ),
                size: buttonSize,
                button: .x
            ),
            // B (right)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .b
            ),
            // A (bottom)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y + actionButtonOffset
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Shoulder buttons (top corners)
        let shoulderButtons: [ButtonLayout] = [
            // L (top-left)
            ButtonLayout(
                position: CGPoint(
                    x: padding + 40,
                    y: 35
                ),
                size: shoulderButtonSize,
                button: .l
            ),
            // R (top-right)
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - padding - 40,
                    y: 35
                ),
                size: shoulderButtonSize,
                button: .r
            )
        ]

        // Start/Select (center-bottom)
        let centerButtons: [ButtonLayout] = [
            // Select
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 - 60,
                    y: screenSize.height - 85
                ),
                size: smallButtonSize,
                button: .select
            ),
            // Start
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 12,
                    y: screenSize.height - 85
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return DSControllerLayoutDefinition(
            mode: .landscape,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            shoulderButtons: shoulderButtons,
            centerButtons: centerButtons
        )
    }

    // MARK: - Portrait Layout

    static func portraitLayout(screenSize: CGSize) -> DSControllerLayoutDefinition {
        let padding: CGFloat = 25
        let buttonSize = CGSize(width: 52, height: 52)
        let dpadRadius: CGFloat = 65
        let smallButtonSize = CGSize(width: 44, height: 22)
        let shoulderButtonSize = CGSize(width: 60, height: 28)

        // Controls positioned lower for DS screens above
        let controlsY = screenSize.height * 0.68

        // D-Pad (lower left)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius + 10,
            y: controlsY
        )

        // Face buttons (lower right)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius - 10,
            y: controlsY
        )

        let actionButtonOffset: CGFloat = 34

        let actionButtons: [ButtonLayout] = [
            // Y (left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .y
            ),
            // X (top)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y - actionButtonOffset
                ),
                size: buttonSize,
                button: .x
            ),
            // B (right)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .b
            ),
            // A (bottom)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y + actionButtonOffset
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Shoulder buttons
        let shoulderButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: padding + 35,
                    y: screenSize.height * 0.50
                ),
                size: shoulderButtonSize,
                button: .l
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - padding - 35,
                    y: screenSize.height * 0.50
                ),
                size: shoulderButtonSize,
                button: .r
            )
        ]

        // Start/Select
        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 - 52,
                    y: screenSize.height - 80
                ),
                size: smallButtonSize,
                button: .select
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 8,
                    y: screenSize.height - 80
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return DSControllerLayoutDefinition(
            mode: .portrait,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            shoulderButtons: shoulderButtons,
            centerButtons: centerButtons
        )
    }
}

struct DSControllerLayoutDefinition {
    let mode: DSControllerLayout.LayoutMode
    let dpad: DSControllerLayout.DPadLayout
    let actionButtons: [DSControllerLayout.ButtonLayout]
    let shoulderButtons: [DSControllerLayout.ButtonLayout]
    let centerButtons: [DSControllerLayout.ButtonLayout]
}
