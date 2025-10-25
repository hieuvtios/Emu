
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

    // MARK: - Landscape Layout (overlay on game screen)

    static func landscapeLayout(screenSize: CGSize) -> GBAControllerLayoutDefinition {
        let baseWidth: CGFloat = 852
        let baseHeight: CGFloat = 393

        let widthRatio = screenSize.width / baseWidth
        let heightRatio = screenSize.height / baseHeight

        let buttonSize = CGSize(width: 68 * heightRatio, height: 68 * heightRatio)
        let dpadRadius: CGFloat = 60 * heightRatio
        let smallButtonSize = CGSize(width: 45 * heightRatio, height: 20 * heightRatio)

        // D-Pad (left side, over game screen)
        let dpadCenter = CGPoint(
            x: screenSize.width * 0.15,
            y: screenSize.height * 0.55
        )

        // Action buttons (right side, over game screen)
        let actionButtonsBaseX = screenSize.width * 0.9
        let actionButtonsBaseY = screenSize.height * 0.55
        let verticalSpacing: CGFloat = 70 * heightRatio
        let horizontalOffset: CGFloat = 35 * widthRatio

        let actionButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsBaseX + horizontalOffset + 50,
                    y: actionButtonsBaseY - (verticalSpacing / 2)
                ),
                size: buttonSize,
                button: .a
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsBaseX - horizontalOffset + 50,
                    y: actionButtonsBaseY + (verticalSpacing / 2)
                ),
                size: buttonSize,
                button: .b
            )
        ]

        // Shoulder buttons (L, R) - top corners, fully on screen
        let shoulderButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(x: screenSize.width * 0.15 - 20, y: 60),
                size: CGSize(width: 80, height: 35),
                button: .l
            ),
            ButtonLayout(
                position: CGPoint(x: screenSize.width - 20, y: 60),
                size: CGSize(width: 80, height: 35),
                button: .r
            )
        ]

        // Center Buttons (Select/Start) - over game screen, bottom-right area
        let centerButtonsY = screenSize.height * 0.89

        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - 50 * widthRatio,
                    y: centerButtonsY
                ),
                size: smallButtonSize,
                button: .select
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width + 25 * widthRatio,
                    y: centerButtonsY
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

    // MARK: - Portrait Layout (GBC-style, buttons below game screen)

    static func portraitLayout(screenSize: CGSize) -> GBAControllerLayoutDefinition {
        // iPhone 17 reference
        let baseWidth: CGFloat = 393
        let baseHeight: CGFloat = 852

        let widthRatio = screenSize.width / baseWidth
        let heightRatio = screenSize.height / baseHeight

        // Scaled constants
        let buttonSize = CGSize(width: 68 * widthRatio, height: 68 * widthRatio)
        let dpadRadius: CGFloat = 60 * widthRatio
        let smallButtonSize = CGSize(width: 45 * widthRatio, height: 20 * heightRatio)

        // Controls area (same relative position as GBC)
        let controlsY = screenSize.height * 0.72 * heightRatio

        // D-Pad (bottom-left)
        let dpadCenter = CGPoint(
            x: 95 * widthRatio,
            y: controlsY + (160 * heightRatio)
        )

        // Action buttons (bottom-right)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - (95 * widthRatio),
            y: controlsY + (160 * heightRatio)
        )

        let diagonalOffset: CGFloat = 28 * widthRatio

        let actionButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - diagonalOffset - 10,
                    y: actionButtonsCenter.y - diagonalOffset
                ),
                size: buttonSize,
                button: .b
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + diagonalOffset,
                    y: actionButtonsCenter.y + diagonalOffset + 10
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Shoulder buttons (L, R)
        let shoulderButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(x: 80, y: controlsY + 25),
                size: CGSize(width: 70, height: 30),
                button: .l
            ),
            ButtonLayout(
                position: CGPoint(x: screenSize.width - 80, y: controlsY + 25),
                size: CGSize(width: 70, height: 30),
                button: .r
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
