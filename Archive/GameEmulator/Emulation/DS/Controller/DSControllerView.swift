//
//  DSControllerView.swift
//  GameEmulator
//
//  Main DS controller view with direct MelonDS integration
//  Nintendo DS authentic layout with SNES visual style
//

import SwiftUI

struct DSControllerView: View {
    let controller: DSGameController
    @State private var layout: DSControllerLayoutDefinition?
    @State private var buttonStates: [DSButtonType: Bool] = [:]
    @State private var dpadButtons: Set<DSButtonType> = []

    @StateObject private var themeManager = DSThemeManager()
    let onMenuButtonTap: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack(alignment:.bottom) {
                    if geometry.size.width > geometry.size.height {
                        Image(themeManager.currentTheme.backgroundPortraitImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .ignoresSafeArea()
                    } else {
                        ZStack(alignment:.top){
                            Image(themeManager.currentTheme.backgroundPortraitImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                                .clipped()

                        }
                    }


                    // Chỉ render UI khi layout không nil
                    if let layout = layout {
                        DSDPadView(
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

//               //

                        // Action buttons (A, B, X, Y)
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
                                },
                                theme: themeManager.currentTheme
                            )
                        }
                        .zIndex(0)

                        // Shoulder buttons (L, R)
                        ForEach(layout.shoulderButtons, id: \.button.rawValue) { buttonLayout in
                            DSShoulderButtonView(button: buttonLayout.button, layout: buttonLayout, isPressed: Binding(
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
                                }, theme: themeManager.currentTheme
                            )
                        }
                        // Menu Button
                        if let firstCenterButton = layout.centerButtons.first {
                            Button(action: {
                                onMenuButtonTap()
                            }) {
                                Image(themeManager.currentTheme.menuButtonImageName)
                            }
                            .position(x: layout.dpad.center.x, y: firstCenterButton.position.y)
                            .zIndex(1)
                        }
                    }
                }
                .ignoresSafeArea()
            }
            .onAppear {
                updateLayout(for: geometry.size)
            }
            .onChange(of: geometry.size) { newSize in
                updateLayout(for: newSize)
            }
        }

    }
    private func updateLayout(for size: CGSize) {
        // Determine orientation based on aspect ratio
        let isLandscape = size.width > size.height

        // Update layout based on orientation
        if isLandscape {
            layout = DSControllerLayout.landscapeLayout(screenSize: size)
        } else {
            layout = DSControllerLayout.portraitLayout(screenSize: size)
        }
    }
}

// Action button background component (circular purple background with diagonal stripe)
struct DSActionButtonBackground: View {
    let center: CGPoint
    let radius: CGFloat

    var body: some View {
        let screen = UIScreen.main.bounds
        let isLandscape = screen.width > screen.height

        ZStack {
            // Base purple circle
            Image(.snesbg1)
                .resizable()
                .zIndex(0)
        }
        .frame(width: isLandscape ? radius * 2 + 20 : radius * 2, height:isLandscape ? radius * 2 + 20 : radius * 2 )
        .position({
            return CGPoint(
                x: center.x + (isLandscape ? 110 : 0),
                y: center.y
            )
        }())
    }
}




#if DEBUG
struct DSControllerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DSControllerView(controller: DSGameController(name: ""), onMenuButtonTap: {})
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("Landscape Mode")

            DSControllerView(controller: DSGameController(name: ""), onMenuButtonTap: {})
                .previewInterfaceOrientation(.portrait)
                .previewDisplayName("Portrait Mode")
        }
    }
}
#endif
//
//  DSControllerLayout.swift
//  GameEmulator
//
//  Layout definitions for Nintendo DS controller
//  Unique dual-screen layout with portrait-style controls
//

struct DSControllerLayout {

    // MARK: - Layout Constants

    enum LayoutMode {
        case landscape
        case portrait
    }

    struct ButtonLayout {
        let position: CGPoint
        let size: CGSize
        let button: DSButtonType
    }

    struct DPadLayout {
        let center: CGPoint
        let radius: CGFloat
    }

    struct TouchScreenLayout {
        let frame: CGRect
        let isTop: Bool  // DS has dual screens
    }

    // MARK: - Landscape Layout

    static func landscapeLayout(screenSize: CGSize) -> DSControllerLayoutDefinition {
        let padding: CGFloat = 35
        let buttonSize = CGSize(width: 58, height: 58)
        let dpadRadius: CGFloat = 75
        let smallButtonSize = CGSize(width: 48, height: 24)
        let shoulderButtonSize = CGSize(width: 65, height: 30)

        // D-Pad (left side)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: screenSize.height / 2 + 20
        )

        // Face buttons (right side) - DS diamond layout like SNES
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius,
            y: screenSize.height / 2 + 20
        )

        let actionButtonOffset: CGFloat = 38

        let actionButtons: [ButtonLayout] = [
            // Y (left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .y
            ),
            // X (top)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y - actionButtonOffset
                ),
                size: buttonSize,
                button: .x
            ),
            // B (right)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .b
            ),
            // A (bottom)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y + actionButtonOffset
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Shoulder buttons (top corners)
        let shoulderButtons: [ButtonLayout] = [
            // L (top-left)
            ButtonLayout(
                position: CGPoint(
                    x: padding + 40,
                    y: 35
                ),
                size: shoulderButtonSize,
                button: .l
            ),
            // R (top-right)
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - padding - 40,
                    y: 35
                ),
                size: shoulderButtonSize,
                button: .r
            )
        ]

        // Start/Select (center-bottom)
        let centerButtons: [ButtonLayout] = [
            // Select
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 - 60,
                    y: screenSize.height - 85
                ),
                size: smallButtonSize,
                button: .select
            ),
            // Start
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 12,
                    y: screenSize.height - 85
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return DSControllerLayoutDefinition(
            mode: .landscape,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            shoulderButtons: shoulderButtons,
            centerButtons: centerButtons,
            actionButtonsCenter: actionButtonsCenter
        )
    }

    // MARK: - Portrait Layout

    static func portraitLayout(screenSize: CGSize) -> DSControllerLayoutDefinition {
        let padding: CGFloat = 25
        let buttonSize = CGSize(width: 52, height: 52)
        let dpadRadius: CGFloat = 65
        let smallButtonSize = CGSize(width: 44, height: 22)
        let shoulderButtonSize = CGSize(width: 60, height: 28)

        // Controls positioned lower for DS screens above
        let controlsY = screenSize.height * 0.95
        // D-Pad (lower left)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius + 10,
            y: controlsY
        )

        // Face buttons (lower right)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius - 10,
            y: controlsY
        )

        let actionButtonOffset: CGFloat = 45

        let actionButtons: [ButtonLayout] = [
            // Y (left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .y
            ),
            // X (top)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y - actionButtonOffset
                ),
                size: buttonSize,
                button: .x
            ),
            // B (right)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .b
            ),
            // A (bottom)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y + actionButtonOffset
                ),
                size: buttonSize,
                button: .a
            )
        ]

        // Shoulder buttons
        let shoulderButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: padding + 70,
                    y: screenSize.height * 0.75
                ),
                size: shoulderButtonSize,
                button: .l
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - padding - 80,
                    y: screenSize.height * 0.75
                ),
                size: shoulderButtonSize,
                button: .r
            )
        ]

        // Start/Select
        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2,
                    y: screenSize.height + 65
                ),
                size: smallButtonSize,
                button: .select
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 100,
                    y: screenSize.height + 65
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return DSControllerLayoutDefinition(
            mode: .portrait,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            shoulderButtons: shoulderButtons,
            centerButtons: centerButtons,
            actionButtonsCenter: actionButtonsCenter
        )
    }
}

struct DSControllerLayoutDefinition {
    let mode: DSControllerLayout.LayoutMode
    let dpad: DSControllerLayout.DPadLayout
    let actionButtons: [DSControllerLayout.ButtonLayout]
    let shoulderButtons: [DSControllerLayout.ButtonLayout]
    let centerButtons: [DSControllerLayout.ButtonLayout]
    let actionButtonsCenter: CGPoint
}
