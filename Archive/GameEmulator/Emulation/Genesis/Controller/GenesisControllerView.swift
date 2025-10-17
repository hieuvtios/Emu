//
//  GenesisControllerView.swift
//  GameEmulator
//
//  Main Genesis controller view
//

import SwiftUI

struct GenesisControllerView: View {
    let controller: GenesisGameController
    let layout: GenesisControllerLayoutDefinition

    @State private var buttonStates: [GenesisButtonType: Bool] = [:]
    @State private var dpadButtons: Set<GenesisButtonType> = []

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                // Semi-transparent background (non-interactive)
                Color.black.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)

                // D-Pad
                GenesisDPadView(
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
                .zIndex(10)

                // Action buttons (A, B, C)
                ForEach(layout.actionButtons, id: \.button.rawValue) { buttonLayout in
                    GenesisButtonView(
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
                    .zIndex(10)
                }

                // Center buttons (Start)
                ForEach(layout.centerButtons, id: \.button.rawValue) { buttonLayout in
                    GenesisCenterButtonView(
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
                    .zIndex(10)
                }

                // 6-button mode buttons (X, Y, Z, Mode) - optional
                ForEach(layout.sixButtonButtons, id: \.button.rawValue) { buttonLayout in
                    GenesisButtonView(
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
                    .zIndex(10)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .allowsHitTesting(true)
        }
        .edgesIgnoringSafeArea(.all)
        .allowsHitTesting(true)
    }
}

// Preview provider
struct GenesisControllerView_Previews: PreviewProvider {
//    static var previews: some View {
//        let controller = GenesisGameController(name: "Genesis Custom Controller", systemPrefix: "genesis", playerIndex: 0)
//
//        let layout = GenesisControllerLayout.landscapeLayout(
//            screenSize: CGSize(width: 844, height: 390)
//        )
//
//        return GenesisControllerView(controller: controller, layout: layout)
//            .previewDevice("iPhone 14 Pro")
//            .previewInterfaceOrientation(.landscapeLeft)
//    }
    
    static var previews: some View {
        let controller = GenesisGameController(name: "Genesis Custom Controller", systemPrefix: "genesis", playerIndex: 0)

        let layout = GenesisControllerLayout.portraitLayout(
            screenSize: CGSize(width: 390, height: 844)
        )

        return GenesisControllerView(controller: controller, layout: layout)
            .previewDevice("iPhone 14 Pro")
            .previewInterfaceOrientation(.portrait)
    }
}


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
            ),
            // X
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + buttonSpacing / 2,
                    y: actionButtonsCenter.y + buttonSpacing / 3 + 200
                ),
                size: buttonSize,
                button: .x
            ),
            // Y
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - buttonSpacing / 2,
                    y: actionButtonsCenter.y - buttonSpacing / 3 + 100
                ),
                size: buttonSize,
                button: .y
            ),
            // Z
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - buttonSpacing / 2 + 100,
                    y: actionButtonsCenter.y + buttonSpacing / 3 + 100
                ),
                size: buttonSize,
                button: .z
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
