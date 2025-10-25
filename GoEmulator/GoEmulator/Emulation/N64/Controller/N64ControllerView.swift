//
//  N64ControllerView.swift
//  GameEmulator
//
//  Main N64 controller view using N64DeltaCore bridge
//  Authentic Nintendo 64 layout with unique C-button cluster
//

import SwiftUI

struct N64ControllerView: View {
    let controller: N64GameController
    let layout: N64ControllerLayoutDefinition
    let onMenuButtonTap: () -> Void

    @State private var buttonStates: [N64ButtonType: Bool] = [:]
    @State private var dpadButtons: Set<N64ButtonType> = []
    @State private var cButtons: Set<N64ButtonType> = []
    @StateObject private var themeManager = N64ThemeManager()
    @State private var currentLayout: N64ControllerLayoutDefinition?

    private func getCurrentTheme() -> N64ControllerTheme {
        #if DEBUG
        return themeManager.currentTheme
        #else
        return .defaultTheme
        #endif
    }
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                ZStack(alignment:.bottom) {
                    // Background - only in portrait mode
                    // In landscape, background is handled by UIKit layer below game view
                    if geometry.size.width > geometry.size.height {
                        Color.clear
                            .ignoresSafeArea()
                    } else {
                        ZStack(alignment:.top){
                            Image(getCurrentTheme().backgroundPortraitImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                                .clipped()
                        }
                    }

                    let isLandscape = geometry.size.width > geometry.size.height

                    // D-Pad
                    N64DPadView(
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
                        }, theme: themeManager.currentTheme
                    )
                    .opacity(isLandscape ? 0.8 : 1.0)
                    .zIndex(1)

                    // Analog Stick (center-left, authentic N64 position)
                    N64AnalogStickView(
                        layout: layout.analogStick,
                        onPositionChange: { x, y in
                            controller.updateAnalogStick(x: x, y: y)
                        },
                        onRelease: {
                            controller.releaseAllAnalogStickButtons()
                        },
                        theme: getCurrentTheme()
                    )
                    .opacity(isLandscape ? 0.8 : 1.0)
                    .zIndex(1)

                    ZStack {
                        // Base purple circle
                        Image(.btnN64AnalogBase)
                            .resizable()
                    }
                    .frame(width: 75 * 2 , height: 75 * 2 )
                    .position(layout.actionButtonsCenter)
                    .opacity(isLandscape ? 0.8 : 1.0)
                    .zIndex(0)
                    ForEach(layout.actionButtons, id: \.button.rawValue) { buttonLayout in
                        N64ButtonView(
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
                    }
                    .opacity(isLandscape ? 0.8 : 1.0)
                    .zIndex(2)
                    
                    // C-Button cluster (unique to N64)
                    N64CButtonView(
                        layout: layout.cButtonCluster,
                        pressedButtons: $cButtons,
                        onPress: { button in
                            controller.pressButton(button)
                        },
                        onRelease: { button in
                            controller.releaseButton(button)
                        }
                    )
                    .opacity(isLandscape ? 0.8 : 1.0)
                    .zIndex(2)

                    // Shoulder buttons (L, R)
                    ForEach(layout.shoulderButtons, id: \.button.rawValue) { buttonLayout in
                        N64ShoulderButtonView(
                            button: buttonLayout.button,
                            layout: buttonLayout,
                            isPressed: Binding(
                                get: { buttonStates[buttonLayout.button] ?? false },
                                set: { buttonStates[buttonLayout.button] = $0 }
                            ), theme: themeManager.currentTheme,
                            onPress: {
                                controller.pressButton(buttonLayout.button)
                            },
                            onRelease: {
                                controller.releaseButton(buttonLayout.button)
                            }
                        )
                    }
                    .opacity(isLandscape ? 0.8 : 1.0)
                    .zIndex(3)
                    
                    // Z button
//                    N64ZButtonView(
//                        layout: layout.zButton,
//                        isPressed: Binding(
//                            get: { buttonStates[.z] ?? false },
//                            set: { buttonStates[.z] = $0 }
//                        ),
//                        onPress: {
//                            controller.pressButton(.z)
//                        },
//                        onRelease: {
//                            controller.releaseButton(.z)
//                        }, theme: themeManager.currentTheme
//                    )
//                    .zIndex(3)
                    
                    // Start button
                    N64StartButtonView(
                        layout: layout.startButton,
                        isPressed: Binding(
                            get: { buttonStates[.start] ?? false },
                            set: { buttonStates[.start] = $0 }
                        ),
                        onPress: {
                            controller.pressButton(.start)
                        },
                        onRelease: {
                            controller.releaseButton(.start)
                        }
                    )
                    .opacity(isLandscape ? 0.8 : 1.0)
                    .zIndex(4)

                    // Menu Button
                    Button(action: {
                        onMenuButtonTap()
                    }) {
                        Image(getCurrentTheme().menuButtonImageName)
                    }
                    .position(x: layout.dpad.center.x, y: layout.startButton.position.y)
                    .opacity(isLandscape ? 0.8 : 1.0)
                    .zIndex(5)
                }
                .ignoresSafeArea()
            }
        }
    }
}


struct N64ControllerLayout {

    // MARK: - Layout Constants

    enum LayoutMode {
        case landscape
        case portrait
    }

    struct ButtonLayout {
        let position: CGPoint
        let size: CGSize
        let button: N64ButtonType
    }

    struct DPadLayout {
        let center: CGPoint
        let radius: CGFloat
    }

    struct CButtonLayout {
        let center: CGPoint
        let buttonSize: CGSize
        let spacing: CGFloat
    }

    // MARK: - Landscape Layout

    static func landscapeLayout(screenSize: CGSize) -> N64ControllerLayoutDefinition {
        let padding: CGFloat = 40
        let buttonSize = CGSize(width: 65, height: 65)
        let dpadRadius: CGFloat = 80
        let cButtonSize = CGSize(width: 45, height: 45)
        let triggerSize = CGSize(width: 85, height: 35)

        // D-Pad (left side)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: screenSize.height / 2
        )

        // A/B buttons (right side, lower)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - 100,
            y: screenSize.height / 2 + 40
        )

        let actionButtons: [ButtonLayout] = [
            // B (lower left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - 35,
                    y: actionButtonsCenter.y + 10
                ),
                size: CGSize(width: 55, height: 55),
                button: .b
            ),
            // A (right, large primary button)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + 35,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .a
            ),
            
        ]

        // C-Buttons (right side, upper) - unique N64 layout
        let cButtonCenter = CGPoint(
            x: screenSize.width - padding - 95,
            y: screenSize.height / 2 - 70
        )

        let cButtonCluster = CButtonLayout(
            center: cButtonCenter,
            buttonSize: cButtonSize,
            spacing: 50
        )

        // Shoulder buttons (top)
        let shoulderButtons: [ButtonLayout] = [
            // L
            ButtonLayout(
                position: CGPoint(x: padding + 80, y: 30),
                size: triggerSize,
                button: .l
            ),
            // R
            ButtonLayout(
                position: CGPoint(x: screenSize.width - padding - 165, y: 30),
                size: triggerSize,
                button: .r
            ),
            ButtonLayout(
                position: CGPoint(x: screenSize.width - padding - 165, y: 30),
                size: triggerSize,
                button: .z
            )
        ]

//        // Z button (below L trigger)
//        let zButton = ButtonLayout(
//            position: CGPoint(x: padding + 80, y: 75),
//            size: CGSize(width: 70, height: 30),
//            button: .z
//        )

        // Start button (center top)
        let startButton = ButtonLayout(
            position: CGPoint(
                x: screenSize.width / 2,
                y: 40
            ),
            size: CGSize(width: 60, height: 30),
            button: .start
        )

        // Analog stick (center-left, authentic N64 position)
        let analogStickCenter = CGPoint(
            x: screenSize.width * 0.35,  // 35% from left, between D-Pad and action buttons
            y: screenSize.height / 2
        )
        let analogStickRadius: CGFloat = 60
        let analogThumbRadius: CGFloat = 25

        let analogStick = AnalogStickLayout(
            center: analogStickCenter,
            radius: analogStickRadius,
            thumbRadius: analogThumbRadius
        )

        return N64ControllerLayoutDefinition(
            mode: .landscape,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            cButtonCluster: cButtonCluster,
            shoulderButtons: shoulderButtons,
//            zButton: zButton,
            startButton: startButton,
            actionButtonsCenter: actionButtonsCenter,
            analogStick: analogStick
        )
    }

    // MARK: - Portrait Layout

    static func portraitLayout(screenSize: CGSize) -> N64ControllerLayoutDefinition {
        let padding: CGFloat = 30
        let buttonSize = CGSize(width: 40, height: 40)
        let dpadRadius: CGFloat = 70
        let cButtonSize = CGSize(width: 40, height: 40)
        let triggerSize = CGSize(width: 75, height: 32)

        let controlsY = screenSize.height * 0.70

        // D-Pad (lower left)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: controlsY + 40
        )

        // A/B buttons (lower right)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - 60,
            y: controlsY
        )

        let actionButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - 30,
                    y: actionButtonsCenter.y - 20
                ),
                size: CGSize(width: 40, height: 40),
                button: .b
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + 35,
                    y: actionButtonsCenter.y - 10
                ),
                size: buttonSize,
                button: .a
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + 30 - 40,
                    y: actionButtonsCenter.y + 40
                ),
                size: buttonSize,
                button: .z
            )
        ]
    
        // C-Buttons cluster (upper right)
        let cButtonCenter = CGPoint(
            x: screenSize.width - padding - 60,
            y: screenSize.height - cButtonSize.height - 40
        )

        let cButtonCluster = CButtonLayout(
            center: cButtonCenter,
            buttonSize: cButtonSize,
            spacing: 45
        )

        // Shoulder buttons
        let shoulderButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(x: padding + 60, y: controlsY - 130),
                size: triggerSize,
                button: .l
            ),
            ButtonLayout(
                position: CGPoint(x: screenSize.width - padding - 50, y: controlsY - 130),
                size: triggerSize,
                button: .r
            )
        ]

        // Z button
//        let zButton = ButtonLayout(
//            position: CGPoint(x: padding + 140, y: controlsY - 80),
//            size: CGSize(width: 65, height: 28),
//            button: .z
//        )

        // Start button
        let startButton = ButtonLayout(
            position: CGPoint(
                x: screenSize.width / 2,
                y: screenSize.height - 100
            ),
            size: CGSize(width: 55, height: 28),
            button: .start
        )

        // Analog stick (center-left in portrait mode)
        let analogStickCenter = CGPoint(
            x: screenSize.width * 0.35,  // 35% from left
            y: controlsY + 10  // Slightly below center of controls area
        )
        let analogStickRadius: CGFloat = 55
        let analogThumbRadius: CGFloat = 22

        let analogStick = AnalogStickLayout(
            center: analogStickCenter,
            radius: analogStickRadius,
            thumbRadius: analogThumbRadius
        )

        return N64ControllerLayoutDefinition(
            mode: .portrait,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            cButtonCluster: cButtonCluster,
            shoulderButtons: shoulderButtons,
//            zButton: zButton,
            startButton: startButton,
            actionButtonsCenter: actionButtonsCenter,
            analogStick: analogStick
        )
    }
}

struct N64ControllerLayoutDefinition {
    let mode: N64ControllerLayout.LayoutMode
    let dpad: N64ControllerLayout.DPadLayout
    let actionButtons: [N64ControllerLayout.ButtonLayout]
    let cButtonCluster: N64ControllerLayout.CButtonLayout
    let shoulderButtons: [N64ControllerLayout.ButtonLayout]
//    let zButton: N64ControllerLayout.ButtonLayout
    let startButton: N64ControllerLayout.ButtonLayout
    let actionButtonsCenter: CGPoint
    let analogStick: N64ControllerLayout.AnalogStickLayout

}
