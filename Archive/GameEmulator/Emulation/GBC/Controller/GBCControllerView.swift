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
                ZStack(alignment:.bottom) {
                    // Background
                    Image("bg 1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: geometry.size.height * 0.4)
                        .clipped()

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
// Preview this view
struct GBCControllerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Portrait Preview
            GBCControllerView(controller: GBCDirectController(name: "Preview Controller"))
                .previewDisplayName("Portrait")
                .previewInterfaceOrientation(.portrait)
            
            // Landscape Preview
            GBCControllerView(controller: GBCDirectController(name: "Preview Controller"))
                .previewDisplayName("Landscape")
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
struct GBCControllerLayout {

    // MARK: - Layout Constants

    enum LayoutMode {
        case landscape
        case portrait
    }

    struct ButtonLayout {
        let position: CGPoint
        let size: CGSize
        let button: GBCButtonType
    }

    struct DPadLayout {
        let center: CGPoint
        let radius: CGFloat
    }

    // MARK: - Landscape Layout

    static func landscapeLayout(screenSize: CGSize) -> GBCControllerLayoutDefinition {
        // Account for 60px bottom black bar
        let effectiveHeight = screenSize.height - 60

        let buttonSize = CGSize(width: 55, height: 55)
        let dpadRadius: CGFloat = 60
        let smallButtonSize = CGSize(width: 45, height: 20)

        // D-Pad (left side, positioned closer to center for better thumb reach)
        let dpadCenter = CGPoint(
            x: 115,  // Fixed position from left edge
            y: effectiveHeight / 2 + 40
        )

        // Action buttons (right side) - Authentic GBC diagonal layout
        // B is upper-left, A is lower-right (diagonal arrangement)
        // Positioned closer together and more centered like reference image
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - 115,  // Mirror position from right edge
            y: effectiveHeight / 2
        )

        // Smaller diagonal offset for tighter button clustering (like real GBC)
        let diagonalOffset: CGFloat = 28

        let actionButtons: [ButtonLayout] = [
            // B (upper-left position)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - diagonalOffset + 60,
                    y: actionButtonsCenter.y - diagonalOffset + 30
                ),
                size: buttonSize,
                button: .b
            ),
            // A (lower-right position)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + diagonalOffset + 60,
                    y: actionButtonsCenter.y + diagonalOffset + 50
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Start/Select (center, positioned just above the black bar)
        let centerButtonsY = effectiveHeight - 35

        let centerButtons: [ButtonLayout] = [
            // Select (left)
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 ,
                    y: centerButtonsY + 50
                ),
                size: smallButtonSize,
                button: .select
            ),
            // Start (right)
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 100,
                    y: centerButtonsY + 50
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return GBCControllerLayoutDefinition(
            mode: .landscape,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            centerButtons: centerButtons
        )
    }

    // MARK: - Portrait Layout

    static func portraitLayout(screenSize: CGSize) -> GBCControllerLayoutDefinition {
        let buttonSize = CGSize(width: 55, height: 55)
        let dpadRadius: CGFloat = 60
        let smallButtonSize = CGSize(width: 45, height: 20)

        // Controls positioned in lower area for comfortable one-handed play
        let controlsY = screenSize.height * 0.72

        // D-Pad (lower left, positioned inward for better reach)
        let dpadCenter = CGPoint(
            x: 95,  // Fixed position from left
            y: controlsY + 70
        )

        // Action buttons (lower right) - Authentic GBC diagonal layout
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - 95,  // Mirror position from right
            y: controlsY + 70
        )

        // Tighter diagonal offset for authentic GBC clustering
        let diagonalOffset: CGFloat = 28

        let actionButtons: [ButtonLayout] = [
            // B (upper-left position)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - diagonalOffset,
                    y: actionButtonsCenter.y - diagonalOffset
                ),
                size: buttonSize,
                button: .b
            ),
            // A (lower-right position)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + diagonalOffset,
                    y: actionButtonsCenter.y + diagonalOffset
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Start/Select (center, positioned above bottom for easy access)
        let centerButtonsY = screenSize.height - 70

        let centerButtons: [ButtonLayout] = [
            // Select (left)
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 - 40,
                    y: centerButtonsY + 70
                ),
                size: smallButtonSize,
                button: .select
            ),
            // Start (right)
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 40,
                    y: centerButtonsY + 70
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return GBCControllerLayoutDefinition(
            mode: .portrait,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            centerButtons: centerButtons
        )
    }
}

struct GBCControllerLayoutDefinition {
    let mode: GBCControllerLayout.LayoutMode
    let dpad: GBCControllerLayout.DPadLayout
    let actionButtons: [GBCControllerLayout.ButtonLayout]
    let centerButtons: [GBCControllerLayout.ButtonLayout]
}
