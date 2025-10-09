import SwiftUI

struct GBCControllerView: View {
    let controller: GBCDirectController

    @State private var buttonStates: [GBCButtonType: Bool] = [:]
    @State private var dpadButtons: Set<GBCButtonType> = []
    @State private var currentLayout: GBCControllerLayoutDefinition?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // MARK: - Main Controller Area
                ZStack {
                    // Background
                    Image("bg 1")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .allowsHitTesting(false)

                    if let layout = currentLayout {
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
                    }
                }
                .ignoresSafeArea()

                // MARK: - Bottom Black Bar
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 60)
                    .ignoresSafeArea(edges: .bottom)
            }
            .ignoresSafeArea()
            .onAppear {
                updateLayout(for: geometry.size)
            }
            .onChange(of: geometry.size) { newSize in
                updateLayout(for: newSize)
            }
        }
    }

    // MARK: - Layout Update

    private func updateLayout(for size: CGSize) {
        // Determine orientation based on aspect ratio
        let isLandscape = size.width > size.height

        // Update layout based on orientation
        if isLandscape {
            currentLayout = GBCControllerLayout.landscapeLayout(screenSize: size)
        } else {
            currentLayout = GBCControllerLayout.portraitLayout(screenSize: size)
        }
    }
}
