//
//  SNESControllerView.swift
//  GameEmulator
//
//  Main SNES controller view with direct Snes9x integration
//

import SwiftUI

struct SNESControllerView: View {
    let controller: SNESDirectController
    let layout: SNESControllerLayoutDefinition

    @State private var buttonStates: [SNESButtonType: Bool] = [:]
    @State private var dpadButtons: Set<SNESButtonType> = []

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)

            // D-Pad
            SNESDPadView(
                layout: layout.dpad,
                pressedButtons: $dpadButtons,
                onDirectionChange: { buttons in
                    // Release all d-pad buttons first
                    controller.releaseAllDPadButtons()

                    // Press new buttons
                    if !buttons.isEmpty {
                        controller.pressDPadButtons(buttons)
                    }
                },
                onRelease: {
                    controller.releaseAllDPadButtons()
                }
            )
            .zIndex(1)

            // Action buttons (A, B, X, Y)
            ForEach(layout.actionButtons, id: \.button.rawValue) { buttonLayout in
                SNESButtonView(
                    button: buttonLayout.button,
                    layout: buttonLayout,
                    isPressed: Binding(
                        get: { buttonStates[buttonLayout.button] ?? false },
                        set: { buttonStates[buttonLayout.button] = $0 }
                    ),
                    onPress: {
                        controller.pressButton(buttonLayout.button)
                    },
                    onRelease: {
                        controller.releaseButton(buttonLayout.button)
                    }
                )
            }

            // Shoulder buttons (L, R)
            ForEach(layout.shoulderButtons, id: \.button.rawValue) { buttonLayout in
                SNESShoulderButtonView(
                    button: buttonLayout.button,
                    layout: buttonLayout,
                    isPressed: Binding(
                        get: { buttonStates[buttonLayout.button] ?? false },
                        set: { buttonStates[buttonLayout.button] = $0 }
                    ),
                    onPress: {
                        controller.pressButton(buttonLayout.button)
                    },
                    onRelease: {
                        controller.releaseButton(buttonLayout.button)
                    }
                )
            }

            // Center buttons (Start, Select)
            ForEach(layout.centerButtons, id: \.button.rawValue) { buttonLayout in
                SNESCenterButtonView(
                    button: buttonLayout.button,
                    layout: buttonLayout,
                    isPressed: Binding(
                        get: { buttonStates[buttonLayout.button] ?? false },
                        set: { buttonStates[buttonLayout.button] = $0 }
                    ),
                    onPress: {
                        controller.pressButton(buttonLayout.button)
                    },
                    onRelease: {
                        controller.releaseButton(buttonLayout.button)
                    }
                ).padding(.bottom,50)
            }
        }
    }
}

// Shoulder button component (rectangular shape)
struct SNESShoulderButtonView: View {
    let button: SNESButtonType
    let layout: SNESControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(isPressed ? Color.gray.opacity(0.9) : Color.gray.opacity(0.6))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
            )
            .overlay(
                Text(button.displayName)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            )
            .frame(width: layout.size.width, height: layout.size.height)
            .position(layout.position)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(
                color: isPressed ? .clear : Color.black.opacity(0.3),
                radius: isPressed ? 0 : 4,
                x: 0,
                y: isPressed ? 0 : 2
            )
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            onPress()
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    }
                    .onEnded { _ in
                        if isPressed {
                            isPressed = false
                            onRelease()
                        }
                    }
            )
    }
}

// Center button component (Start/Select - smaller oval buttons)
struct SNESCenterButtonView: View {
    let button: SNESButtonType
    let layout: SNESControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void

    var body: some View {
        Capsule()
            .fill(isPressed ? Color.gray.opacity(0.8) : Color.gray.opacity(0.5))
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
            )
            .overlay(
                Text(button.displayName)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            )
            .frame(width: layout.size.width, height: layout.size.height)
            .position(layout.position)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(
                color: isPressed ? .clear : Color.black.opacity(0.3),
                radius: isPressed ? 0 : 3,
                x: 0,
                y: isPressed ? 0 : 1
            )
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            onPress()
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
                    .onEnded { _ in
                        if isPressed {
                            isPressed = false
                            onRelease()
                        }
                    }
            )
    }
}

// Preview provider
struct SNESControllerView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SNESDirectController(name: "SNES Direct Controller", playerIndex: 0)

        let layout = SNESControllerLayout.portraitLayout(
            screenSize: CGSize(width: 390, height: 844)
        )

        return SNESControllerView(controller: controller, layout: layout)
            .previewDevice("iPhone 14 Pro")
            .previewInterfaceOrientation(.portrait)
    }
}
struct SNESControllerLayout {

    // MARK: - Layout Constants

    enum LayoutMode {
        case landscape
        case portrait
    }

    struct ButtonLayout {
        let position: CGPoint
        let size: CGSize
        let button: SNESButtonType
    }

    struct DPadLayout {
        let center: CGPoint
        let radius: CGFloat
    }

    // MARK: - Landscape Layout

    static func landscapeLayout(screenSize: CGSize) -> SNESControllerLayoutDefinition {
        let padding: CGFloat = 40
        let buttonSize = CGSize(width: 60, height: 60)
        let dpadRadius: CGFloat = 80
        let smallButtonSize = CGSize(width: 50, height: 25)

        // D-Pad (left side)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: screenSize.height / 2
        )

        // Action buttons (right side) - SNES diamond layout
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius,
            y: screenSize.height / 2
        )

        let actionButtonOffset: CGFloat = 50

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
            ),
            // Y (top)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y - actionButtonOffset
                ),
                size: buttonSize,
                button: .y
            ),
            // X (bottom)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y + actionButtonOffset
                ),
                size: buttonSize,
                button: .x
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

        // Start/Select (center)
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

        return SNESControllerLayoutDefinition(
            mode: .landscape,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            shoulderButtons: shoulderButtons,
            centerButtons: centerButtons
        )
    }

    // MARK: - Portrait Layout

    static func portraitLayout(screenSize: CGSize) -> SNESControllerLayoutDefinition {
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

        // Action buttons (lower right)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius,
            y: controlsY
        )

        let actionButtonOffset: CGFloat = 45

        let actionButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .b
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .a
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y - actionButtonOffset
                ),
                size: buttonSize,
                button: .y
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y + actionButtonOffset
                ),
                size: buttonSize,
                button: .x
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

        return SNESControllerLayoutDefinition(
            mode: .portrait,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            shoulderButtons: shoulderButtons,
            centerButtons: centerButtons
        )
    }
}

struct SNESControllerLayoutDefinition {
    let mode: SNESControllerLayout.LayoutMode
    let dpad: SNESControllerLayout.DPadLayout
    let actionButtons: [SNESControllerLayout.ButtonLayout]
    let shoulderButtons: [SNESControllerLayout.ButtonLayout]
    let centerButtons: [SNESControllerLayout.ButtonLayout]
}
