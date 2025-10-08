//
//  GenesisControllerLayout.swift
//  GameEmulator
//
//  Layout definitions for Genesis controller
//

import SwiftUI

struct GenesisControllerLayout {

    // MARK: - Layout Constants

    enum LayoutMode {
        case landscape
        case portrait
    }

    struct ButtonLayout {
        let position: CGPoint
        let size: CGSize
        let button: GenesisButtonType
    }

    struct DPadLayout {
        let center: CGPoint
        let radius: CGFloat
    }

    // MARK: - Landscape Layout

    static func landscapeLayout(screenSize: CGSize) -> GenesisControllerLayoutDefinition {
        let padding: CGFloat = 40
        let buttonSize = CGSize(width: 60, height: 60)
        let dpadRadius: CGFloat = 80
        let smallButtonSize = CGSize(width: 60, height: 25)

        // D-Pad (left side)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: screenSize.height / 2
        )

        // Action buttons (right side) - Genesis has 3-button layout (A, B, C)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius,
            y: screenSize.height / 2
        )

        let buttonSpacing: CGFloat = 70

        let actionButtons: [ButtonLayout] = [
            // A (bottom-right, primary button)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + buttonSpacing / 2,
                    y: actionButtonsCenter.y + buttonSpacing / 3
                ),
                size: buttonSize,
                button: .a
            ),
            // B (top-left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - buttonSpacing / 2,
                    y: actionButtonsCenter.y - buttonSpacing / 3
                ),
                size: buttonSize,
                button: .b
            ),
            // C (bottom-left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - buttonSpacing / 2,
                    y: actionButtonsCenter.y + buttonSpacing / 3
                ),
                size: buttonSize,
                button: .c
            )
        ]

        // Start button (center-bottom)
        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2,
                    y: screenSize.height - 90
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        // 6-button mode optional buttons (X, Y, Z, Mode) - disabled for now
        let sixButtonButtons: [ButtonLayout] = []

        return GenesisControllerLayoutDefinition(
            mode: .landscape,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            centerButtons: centerButtons,
            sixButtonButtons: sixButtonButtons
        )
    }

    // MARK: - Portrait Layout

    static func portraitLayout(screenSize: CGSize) -> GenesisControllerLayoutDefinition {
        let padding: CGFloat = 30
        let buttonSize = CGSize(width: 55, height: 55)
        let dpadRadius: CGFloat = 70
        let smallButtonSize = CGSize(width: 55, height: 22)

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

        let buttonSpacing: CGFloat = 60

        let actionButtons: [ButtonLayout] = [
            // A (bottom-right)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + buttonSpacing / 2,
                    y: actionButtonsCenter.y + buttonSpacing / 3
                ),
                size: buttonSize,
                button: .a
            ),
            // B (top-left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - buttonSpacing / 2,
                    y: actionButtonsCenter.y - buttonSpacing / 3
                ),
                size: buttonSize,
                button: .b
            ),
            // C (bottom-left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - buttonSpacing / 2,
                    y: actionButtonsCenter.y + buttonSpacing / 3
                ),
                size: buttonSize,
                button: .c
            )
        ]

        // Start button
        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2,
                    y: screenSize.height - 90
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        // 6-button mode optional buttons - disabled for now
        let sixButtonButtons: [ButtonLayout] = []

        return GenesisControllerLayoutDefinition(
            mode: .portrait,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            centerButtons: centerButtons,
            sixButtonButtons: sixButtonButtons
        )
    }
}

struct GenesisControllerLayoutDefinition {
    let mode: GenesisControllerLayout.LayoutMode
    let dpad: GenesisControllerLayout.DPadLayout
    let actionButtons: [GenesisControllerLayout.ButtonLayout]
    let centerButtons: [GenesisControllerLayout.ButtonLayout]
    let sixButtonButtons: [GenesisControllerLayout.ButtonLayout]
}
