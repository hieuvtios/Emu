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
        GeometryReader { geometry in
            
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
            .ignoresSafeArea()
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
        .frame(width: radius * 2 , height: radius * 2 )
        .position(center)
    }
}

struct SNESControllerView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SNESDirectController(name: "SNES Direct Controller", playerIndex: 0)

        let layout = SNESControllerLayout.portraitLayout(
            screenSize: CGSize(width: 390, height: 844)
        )

        return SNESControllerView(controller: controller)
            .previewDevice("iPhone 14 Pro")
            .previewInterfaceOrientation(.portrait)
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
        let buttonSize = CGSize(width: 60, height: 60)
        let dpadRadius: CGFloat = 80
        let smallButtonSize = CGSize(width: 50, height: 25)

        // D-Pad (left side)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
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
                    x: actionButtonsCenter.x - actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .x
            ),
            // A (right)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + actionButtonOffset,
                    y: actionButtonsCenter.y
                ),
                size: buttonSize,
                button: .a
            ),
            // Y (top)
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y - actionButtonOffset
                ),
                size: buttonSize,
                button: .y
            ),
        
            
            // B (left)
            ButtonLayout(
         
                position: CGPoint(
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y + actionButtonOffset
                ),
                size: buttonSize,
                button: .b
            )
        ]

        // Shoulder buttons (top)
        let shoulderButtons: [ButtonLayout] = [
            // L
            ButtonLayout(
                position: CGPoint(x: padding + 60, y: 30),
                size: CGSize(width: 80, height: 35),
                button: .l
            ),
            // R
            ButtonLayout(
                position: CGPoint(x: screenSize.width - padding - 140, y: 30),
                size: CGSize(width: 80, height: 35),
                button: .r
            )
        ]

        // Start/Select (center)
        let centerButtons: [ButtonLayout] = [
            // Select
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 100,
                    y: screenSize.height - 90
                ),
                size: smallButtonSize,
                button: .select
            ),
            // Start
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2,
                    y: screenSize.height - 90
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
        let buttonSize = CGSize(width: 55, height: 55)
        let dpadRadius: CGFloat = 70
        let smallButtonSize = CGSize(width: 45, height: 22)

        let controlsY = screenSize.height * 0.8

        // D-Pad (lower left)
        let dpadCenter = CGPoint(
            x: padding + dpadRadius,
            y: controlsY
        )

        // Action buttons (lower right)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - padding - dpadRadius,
            y: controlsY
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
                    x: actionButtonsCenter.x + actionButtonOffset,
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
                    x: actionButtonsCenter.x,
                    y: actionButtonsCenter.y + actionButtonOffset
                ),
                size: buttonSize,
                button: .b
            ),
           
        ]
        
        // Shoulder buttons
        let shoulderButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(x: screenSize.width / 4, y: controlsY - 130),
                size: CGSize(width: 70, height: 30),
                button: .l
            ),
            ButtonLayout(
                position: CGPoint(x: screenSize.width - screenSize.width / 4, y: controlsY - 130),
                size: CGSize(width: 70, height: 30),
                button: .r
            )
        ]

        // Start/Select
        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - smallButtonSize.width - 25 - smallButtonSize.width - 30,
                    y: screenSize.height - 40
                ),
                size: smallButtonSize,
                button: .select
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width - smallButtonSize.width - 15,
                    y: screenSize.height - 40
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
