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
    @StateObject private var themeManager = GenesisThemeManager()

    @State private var buttonStates: [GenesisButtonType: Bool] = [:]
    @State private var dpadButtons: Set<GenesisButtonType> = []
    @State private var showThemePicker:Bool = false
    let onMenuButtonTap: () -> Void
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Semi-transparent background (non-interactive)
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
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.45)
                            .clipped()

                    }
                }

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
                    }, theme: themeManager.currentTheme
                )
                .zIndex(10)
                // Action buttons (A, B, C) with shared blue background
                ZStack {
                    // Bottom row background (blue) - A, B, C
                    Image("btn_genesis_blue")
                        .position(
                            CGPoint(
                                x: layout.actionButtons.filter { [.a, .b, .c].contains($0.button) }
                                    .map { $0.position.x }.reduce(0, +) / 3,
                                y: layout.actionButtons.filter { [.a, .b, .c].contains($0.button) }
                                    .map { $0.position.y }.reduce(0, +) / 3
                            )
                        )
                        .zIndex(0)

                    // Top row background (purple) - X, Y, Z
                    Image("btn_genesis_purple")
                        .position(
                            CGPoint(
                                x: layout.actionButtons.filter { [.x, .y, .z].contains($0.button) }
                                    .map { $0.position.x }.reduce(0, +) / 3,
                                y: layout.actionButtons.filter { [.x, .y, .z].contains($0.button) }
                                    .map { $0.position.y }.reduce(0, +) / 3
                            )
                        )
                        .zIndex(0)

                    // Buttons A, B, C, X, Y, Z
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
                            },
                            theme: themeManager.currentTheme
                        )
                        .zIndex(10)
                    }
                }
                

                // Center buttons (Start)
                ForEach(layout.centerButtons, id: \.button.rawValue) { buttonLayout in
                    GenesisCenterButtonView(
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
                    .zIndex(0)
                    .position(x: buttonLayout.position.x, y: buttonLayout.position.y)

                }
                let isLandscape = geometry.size.width > geometry.size.height
                // Menu Button
                Button(action: {
                    onMenuButtonTap()
                }) {
                    Image(themeManager.currentTheme.menuButtonImageName)
                }
                .position(x: isLandscape ? layout.dpad.center.x - 50 : layout.dpad.center.x, y: isLandscape ? layout.dpad.center.y + layout.dpad.radius + 80 : layout.dpad.center.y + layout.dpad.radius + 80)
                .zIndex(1)
                ZStack{
                 
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
                            }, theme: themeManager.currentTheme
                        )
                        .zIndex(0)
                    }
                }
                
//#if DEBUG
//// Theme Picker Button (Debug Only)
//Button(action: {
//    showThemePicker = true
//}) {
//    Image(systemName: "paintbrush.fill")
//        .font(.system(size: 20))
//        .foregroundColor(.white)
//        .padding(12)
//        .background(Circle().fill(Color.blue.opacity(0.8)))
//        .shadow(radius: 4)
//}
//.position(x: geometry.size.width - 40, y: 40)
//.zIndex(1)
//#endif
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .allowsHitTesting(true)
            .sheet(isPresented: $showThemePicker) {
                GenesisThemePickerView(themeManager: themeManager)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .allowsHitTesting(true)
    }
}

// Preview provider
struct GenesisControllerView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = GenesisGameController(
            name: "Genesis Custom Controller",
            systemPrefix: "genesis",
            playerIndex: 0
        )

        return Group {
            // Portrait
            let portraitSize = CGSize(width: 390, height: 844)
            GenesisControllerView(
                controller: controller,
                layout: GenesisControllerLayout.portraitLayout(screenSize: portraitSize),
                onMenuButtonTap: { print("Menu tapped") }
            )
            .previewDevice("iPhone 14 Pro")
            .previewInterfaceOrientation(.portrait)
            .previewDisplayName("iPhone 14 Pro – Portrait")

            // Landscape
            let landscapeSize = CGSize(width: 844, height: 390)
            GenesisControllerView(
                controller: controller,
                layout: GenesisControllerLayout.landscapeLayout(screenSize: landscapeSize),
                onMenuButtonTap: { print("Menu tapped") }
            )
            .previewDevice("iPhone 14 Pro")
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("iPhone 14 Pro – Landscape")
        }
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
            x: padding + dpadRadius - 10,
            y: screenSize.height / 2
        )

        // Action buttons (right side) - Two rows of 3 buttons each
        let rightSideX = screenSize.width - padding - 50
        let topRowY = screenSize.height / 2 - 40
        let bottomRowY = screenSize.height / 2 + 40
        let buttonHorizontalSpacing: CGFloat = 65

        let actionButtons: [ButtonLayout] = [
            // Bottom row (A, B, C) - left to right
            ButtonLayout(
                position: CGPoint(x: rightSideX - buttonHorizontalSpacing + 10, y: bottomRowY + padding + 10),
                size: buttonSize,
                button: .a
            ),
            ButtonLayout(
                position: CGPoint(x: rightSideX, y: bottomRowY + padding - 20),
                size: buttonSize,
                button: .b
            ),
            ButtonLayout(
                position: CGPoint(x: rightSideX + buttonHorizontalSpacing - 10, y: bottomRowY ),
                size: buttonSize,
                button: .c
            ),
            // Top row (X, Y, Z) - left to right
            ButtonLayout(
                position: CGPoint(x: rightSideX - buttonHorizontalSpacing, y: topRowY + padding),
                size: buttonSize,
                button: .x
            ),
            ButtonLayout(
                position: CGPoint(x: rightSideX - 10, y: topRowY + 10),
                size: buttonSize,
                button: .y
            ),
            ButtonLayout(
                position: CGPoint(x: rightSideX + buttonHorizontalSpacing - 15, y: topRowY - 15),
                size: buttonSize,
                button: .z
            )
        ]

        // Start button (top center)
        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - screenSize.width / 6,
                    y: 60
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        // 6-button mode optional buttons - disabled for now
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

        let controlsY = screenSize.height * 0.7

        // D-Pad (lower left)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: controlsY + 60
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
                    x: actionButtonsCenter.x - buttonSpacing / 2 - 20,
                    y: actionButtonsCenter.y + buttonSpacing / 3 + 25 + 150
                ),
                size: buttonSize,
                button: .a
            )
            ,
            // B (top-left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + buttonSpacing / 2 - 30,
                    y: actionButtonsCenter.y + buttonSpacing / 3 - 5 + 150
                ),
                size: buttonSize,
                button: .b
            ),
            // C (bottom-left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - buttonSpacing / 2 + 85,
                    y: actionButtonsCenter.y + buttonSpacing / 3 - 30 + 150
                ),
                size: buttonSize,
                button: .c
            ),
            
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - buttonSpacing / 2 - 15,
                    y: actionButtonsCenter.y + buttonSpacing / 3 + 45
                ),
                size: buttonSize,
                button: .x
            )
            ,
            // Y (top-left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + buttonSpacing / 2 - 25,
                    y: actionButtonsCenter.y + buttonSpacing / 3 - 25 + 40
                ),
                size: buttonSize,
                button: .y
            ),
            // Z (bottom-left)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - buttonSpacing / 2 + 88,
                    y: actionButtonsCenter.y + buttonSpacing / 3 - 45 + 40
                ),
                size: buttonSize,
                button: .z
            )
        ]

        // Start button
        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - screenSize.width / 4 ,
                    y: screenSize.height - 320
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
