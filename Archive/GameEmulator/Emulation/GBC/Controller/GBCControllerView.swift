import SwiftUI

struct GBCControllerView: View {
    let controller: GBCDirectController
    let layout: GBCControllerLayoutDefinition

    @State private var buttonStates: [GBCButtonType: Bool] = [:]
    @State private var dpadButtons: Set<GBCButtonType> = []

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Main Controller Area
            ZStack {
                // Background
                Image("bg 1")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                // D-Pad
                GBCDPadView(
                    layout: layout.dpad,
                    pressedButtons: $dpadButtons,
                    onDirectionChange: { buttons in
                        controller.releaseAllDPadButtons()
                        if !buttons.isEmpty {
                            controller.pressDPadButtons(buttons)
                        }
                    },
                    onRelease: {
                        controller.releaseAllDPadButtons()
                    }
                )
                .zIndex(1)

                // Action Buttons
                ForEach(layout.actionButtons, id: \.button.rawValue) { buttonLayout in
                    GBCButtonView(
                        button: buttonLayout.button,
                        layout: buttonLayout,
                        isPressed: Binding(
                            get: { buttonStates[buttonLayout.button] ?? false },
                            set: { buttonStates[buttonLayout.button] = $0 }
                        ),
                        onPress: { controller.pressButton(buttonLayout.button) },
                        onRelease: { controller.releaseButton(buttonLayout.button) }
                    )
                    .offset(
                        x: buttonLayout.button == .b ? 0 : 0,
                        y: buttonLayout.button == .b ? 30 : -20
                    )
                }

                // Center Buttons (Start, Select)
                ForEach(layout.centerButtons, id: \.button.rawValue) { buttonLayout in
                    GBCCenterButtonView(
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
                .padding(.bottom, 50)
            }
            .ignoresSafeArea()

            // MARK: - Bottom Black Bar
            Rectangle()
                .fill(Color.black)
                .frame(height: 60)
                .ignoresSafeArea(edges: .bottom)
        }
        .ignoresSafeArea()

    }
}
