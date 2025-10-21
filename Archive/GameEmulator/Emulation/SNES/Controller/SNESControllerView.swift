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
    let onMenuButtonTap: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack(alignment:.bottom) {
                    
                    // Semi-transparent background
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
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                                .clipped()
                            
                        }
                    }
                    
                    
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
                            radius: 100
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
                        .zIndex(0)
                        
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
            layout = SNESControllerLayout.landscapeLayout(screenSize: size)
        } else {
            layout = SNESControllerLayout.portraitLayout(screenSize: size)
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


struct SNESControllerLayout {

    // MARK: - Layout Constants

    enum LayoutMode {
        case landscape
        case portrait
    }

    struct ButtonLayout {
        let position: CGPoint
        let size: CGSize
        let button: SNESButtonType
    }

    struct DPadLayout {
        let center: CGPoint
        let radius: CGFloat
    }

    // MARK: - Landscape Layout

    static func landscapeLayout(screenSize: CGSize) -> SNESControllerLayoutDefinition {
        let padding: CGFloat = 40
        let buttonSize = CGSize(width: 50, height: 50)
        let dpadRadius: CGFloat = 80
        let smallButtonSize = CGSize(width: 50, height: 25)

        // D-Pad (left side)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius + 10,
            y: screenSize.height / 2
        )

        // Action buttons (right side) - SNES diamond layout
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius,
            y: screenSize.height / 2
        )

        let actionButtonOffset: CGFloat = 50

        let actionButtons: [ButtonLayout] = [
            // X (top)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonOffset + 111,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .x
            ),
            // A (right)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + actionButtonOffset + 110,
                    y: actionButtonsCenter.y - 2
                ),
                size: buttonSize,
                button: .a
            ),
            // Y (top)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + 108,
                    y: actionButtonsCenter.y - actionButtonOffset
                ),
                size: buttonSize,
                button: .y
            ),
        
            
            // B (left)
            ButtonLayout(
         
                position: CGPoint(
                    x: actionButtonsCenter.x + 110,
                    y: actionButtonsCenter.y + actionButtonOffset - 2
                ),
                size: buttonSize,
                button: .b
            )
        ]

        // Shoulder buttons (top)
        let shoulderButtons: [ButtonLayout] = [
            // L
            ButtonLayout(
                position: CGPoint(x: dpadCenter.x - 15, y: 40),
                size: CGSize(width: 80, height: 35),
                button: .l
            ),
            // R
            ButtonLayout(
                position: CGPoint(x: screenSize.width -  screenSize.width / 4 / 2 + 90, y:40),
                size: CGSize(width: 80, height: 35),
                button: .r
            )
        ]

        // Start/Select (center)
        let centerButtons: [ButtonLayout] = [
            // Select
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width + 35,
                    y: screenSize.height - 10
                ),
                size: smallButtonSize,
                button: .select
            ),
            // Start
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - 50,
                    y: screenSize.height - 10
                ),
                size: smallButtonSize,
                button: .start
            )
        ]
      
        return SNESControllerLayoutDefinition(
            mode: .landscape,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            shoulderButtons: shoulderButtons,
            centerButtons: centerButtons,
            actionButtonsCenter: actionButtonsCenter
        )
    }

    // MARK: - Portrait Layout

    static func portraitLayout(screenSize: CGSize) -> SNESControllerLayoutDefinition {
        let padding: CGFloat = 30
        let buttonSize = CGSize(width: 50, height: 50)
        let dpadRadius: CGFloat = 70
        let smallButtonSize = CGSize(width: 45, height: 22)

        let controlsY = screenSize.height * 0.9

        // D-Pad (lower left)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius - 10,
            y: controlsY - 20
        )

        // Action buttons (lower right)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius,
            y: controlsY - 20
        )

        let actionButtonOffset: CGFloat = 45

        let actionButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .y
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + actionButtonOffset - 1,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .a
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y - actionButtonOffset
                ),
                size: buttonSize,
                button: .x
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + 1,
                    y: actionButtonsCenter.y + actionButtonOffset - 1
                ),
                size: buttonSize,
                button: .b
            ),
           
        ]
        
        // Shoulder buttons
        let shoulderButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(x: screenSize.width / 4 - 20, y: controlsY - 160),
                size: CGSize(width: 70, height: 30),
                button: .l
            ),
            ButtonLayout(
                position: CGPoint(x: screenSize.width - screenSize.width / 4 + 10, y: controlsY - 160),
                size: CGSize(width: 70, height: 30),
                button: .r
            )
        ]

        // Start/Select
        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - smallButtonSize.width - 25 - smallButtonSize.width - 30,
                    y: screenSize.height + 40
                ),
                size: smallButtonSize,
                button: .select
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - smallButtonSize.width - 15,
                    y: screenSize.height + 40
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return SNESControllerLayoutDefinition(
            mode: .portrait,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            shoulderButtons: shoulderButtons,
            centerButtons: centerButtons,
            actionButtonsCenter: actionButtonsCenter
        )
    }
}

struct SNESControllerLayoutDefinition {
    let mode: SNESControllerLayout.LayoutMode
    let dpad: SNESControllerLayout.DPadLayout
    let actionButtons: [SNESControllerLayout.ButtonLayout]
    let shoulderButtons: [SNESControllerLayout.ButtonLayout]
    let centerButtons: [SNESControllerLayout.ButtonLayout]
    let actionButtonsCenter: CGPoint
}
// MARK: - Preview

struct SNESControllerView_Previews: PreviewProvider {
    static var previews: some View {
        // Landscape Preview
        SNESControllerView(
            controller: SNESDirectController(name: "Preview Controller"),
            onMenuButtonTap: { print("Menu tapped") }
        )
            .previewDisplayName("Landscape")
            .previewInterfaceOrientation(.portrait)
    }
}
