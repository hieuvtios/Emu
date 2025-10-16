//
//  SNESControllerView.swift
//  GameEmulator
//
//  Main SNES controller view with direct Snes9x integration
//

import SwiftUI

struct SNESControllerView: View {
    let controller: SNESDirectController
    @State private var layout: SNESControllerLayoutDefinition?
    @State private var buttonStates: [SNESButtonType: Bool] = [:]
    @State private var dpadButtons: Set<SNESButtonType> = []
    @StateObject private var themeManager = SNESThemeManager()

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)

            // Chỉ render UI khi layout không nil
            if let layout = layout {
                SNESDPadView(
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
                    }, theme: themeManager.currentTheme
                )
                .zIndex(1)

                // Action buttons background
                SNESActionButtonBackground(
                    center: layout.actionButtonsCenter,
                    radius: 105
                )
                .zIndex(0)

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
                            },
                            theme: themeManager.currentTheme
                        )
                    }
                    .zIndex(2)

                // Shoulder buttons (L, R)
                ForEach(layout.shoulderButtons, id: \.button.rawValue) { buttonLayout in
                    SNESShoulderButtonView(button: buttonLayout.button, layout: buttonLayout, isPressed: Binding(
                        get: { buttonStates[buttonLayout.button] ?? false },
                        set: { buttonStates[buttonLayout.button] = $0 }
                    ), theme: themeManager.currentTheme) {
                        controller.pressButton(buttonLayout.button)
                    } onRelease: {
                        controller.releaseButton(buttonLayout.button)
                    }
                }
                .zIndex(2)


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
                        }, theme: themeManager.currentTheme
                    )
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            // Tính toán layout dựa trên kích thước màn hình khi view xuất hiện
            let screenSize = UIScreen.main.bounds.size
            layout = SNESControllerLayout.portraitLayout(screenSize: screenSize)
        }
    }
}

// Shoulder button component (rectangular shape)
struct SNESShoulderButtonView: View {
    let button: SNESButtonType
    let layout: SNESControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let theme: SNESControllerTheme
    let onPress: () -> Void
    let onRelease: () -> Void
    private var buttonImageName: String {
        switch button {
        case .l:
            return theme.leftButtonImageName
        case .r:
            return theme.rightButtonImageName
        default:
            return "button_default"
        }
    }
    var body: some View {
        ZStack {
            // Button background image
            Image(buttonImageName)
        }
            .frame(width: layout.size.width, height: layout.size.height)
            .position(layout.position)
            .scaleEffect(isPressed ? 0.95 : 1.0)

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
    let theme: SNESControllerTheme

    var body: some View {
        ZStack {
            // Button background image
            Image(buttonImageName)
        }
        .frame(width: layout.size.width, height: layout.size.height)
        .position(layout.position)
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

    // MARK: - Helpers

    private var buttonImageName: String {
        switch button {
        case .start:
            return theme.startButtonImageName
        case .select:
            return theme.selectButtonImageName
        default:
            return "button_default"
        }
    }
}


// Action button background component (circular purple background with diagonal stripe)
struct SNESActionButtonBackground: View {
    let center: CGPoint
    let radius: CGFloat

    var body: some View {
        ZStack {
            // Base purple circle
            Image(.snesbg1)
                .resizable()

        }
        .frame(width: radius * 2 + 10, height: radius * 2 + 10)
        .position(center)
    }
}

// Preview provider
//struct SNESControllerView_Previews: PreviewProvider {
//    static var previews: some View {
//        let controller = SNESDirectController(name: "SNES Direct Controller", playerIndex: 0)
//
//        let layout = SNESControllerLayout.portraitLayout(
//            screenSize: CGSize(width: 390, height: 844)
//        )
//
//        return SNESControllerView(controller: controller)
//            .previewDevice("iPhone 14 Pro")
//            .previewInterfaceOrientation(.portrait)
//    }
//}
