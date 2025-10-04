//
//  GBCControllerView.swift
//  GameEmulator
//
//  Main GBC controller view with direct Gambatte integration
//

import SwiftUI

struct GBCControllerView: View {
    let controller: GBCDirectController
    let layout: GBCControllerLayoutDefinition

    @State private var buttonStates: [GBCButtonType: Bool] = [:]
    @State private var dpadButtons: Set<GBCButtonType> = []

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)

            // D-Pad
            GBCDPadView(
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
                GBCButtonView(
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
                ).padding(.bottom, 50)
            }
        }
    }
}

// Center button component (Start/Select - smaller oval buttons)
struct GBCCenterButtonView: View {
    let button: GBCButtonType
    let layout: GBCControllerLayout.ButtonLayout
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
struct GBCControllerView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = GBCDirectController(name: "GBC Direct Controller", playerIndex: 0)

        let layout = GBCControllerLayout.landscapeLayout(
            screenSize: CGSize(width: 844, height: 390)
        )

        return GBCControllerView(controller: controller, layout: layout)
            .previewDevice("iPhone 14 Pro")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
