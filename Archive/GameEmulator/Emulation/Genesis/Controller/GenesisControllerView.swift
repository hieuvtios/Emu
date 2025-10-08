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
    static var previews: some View {
        let controller = GenesisGameController(name: "Genesis Custom Controller", systemPrefix: "genesis", playerIndex: 0)

        let layout = GenesisControllerLayout.landscapeLayout(
            screenSize: CGSize(width: 844, height: 390)
        )

        return GenesisControllerView(controller: controller, layout: layout)
            .previewDevice("iPhone 14 Pro")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
