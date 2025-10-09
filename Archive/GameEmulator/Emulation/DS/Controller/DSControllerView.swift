//
//  GBAControllerView.swift
//  GameEmulator
//
//  Main GBA controller view with direct mGBA integration
//  Authentic Game Boy Advance layout
//

import SwiftUI

struct DSControllerView: View {
    let controller: DSGameController
    let layout: DSControllerLayoutDefinition

    @State private var buttonStates: [DSButtonType: Bool] = [:]
    @State private var dpadButtons: Set<DSButtonType> = []

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)

            // D-Pad
            DSDPadView(
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

            // Action buttons (A, B)
            ForEach(layout.actionButtons, id: \.button.rawValue) { buttonLayout in
                DSButtonView(
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
                DSShoulderButtonView(
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
                DSCenterButtonView(
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
                ).padding(.bottom, 50)
            }
        }
    }
}

