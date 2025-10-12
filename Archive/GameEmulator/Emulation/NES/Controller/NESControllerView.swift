//
//  NESControllerView.swift
//  GameEmulator
//
//  Main NES controller view
//

import SwiftUI

struct NESControllerView: View {
    let controller: NESGameController
    let layout: NESControllerLayoutDefinition
    @State private var currentLayout: NESControllerLayoutDefinition?

    @State private var buttonStates: [NESButtonType: Bool] = [:]
    @State private var dpadButtons: Set<NESButtonType> = []
    #if DEBUG
    @StateObject private var themeManager = NESThemeManager()
    @State private var showThemePicker = false
    #endif

    private func getCurrentTheme() -> NESControllerTheme {
        #if DEBUG
        return themeManager.currentTheme
        #else
        return .defaultTheme
        #endif
    }
    
    private func updateLayout(for size: CGSize) {
        // Determine orientation based on aspect ratio
        let isLandscape = size.width > size.height

        // Update layout based on orientation
        if isLandscape {
            currentLayout = NESControllerLayout.landscapeLayout(screenSize: size)
        } else {
            currentLayout = NESControllerLayout.portraitLayout(screenSize: size)
        }
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if geometry.size.width > geometry.size.height {
                    Image(getCurrentTheme().backgroundLandscapeImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                } else {
                    ZStack(alignment:.top){
                      Image(getCurrentTheme().backgroundPortraitImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                            .clipped()
                        HStack(alignment:.top) {
                            Image(.btnLeft)
                                .aspectRatio(contentMode: .fit)
                                .offset(CGSizeMake(0, -7))
                            Spacer()
                            Image(.btnRight)
                                .aspectRatio(contentMode: .fit)
                                .offset(CGSizeMake(0, -7))

                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                    }
                }

                // D-Pad
                NESDPadView(
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
                    }, theme: getCurrentTheme()
                )
                .zIndex(10)

                // Action buttons (A, B)
                ForEach(layout.actionButtons, id: \.button.rawValue) { buttonLayout in
                    NESButtonView(
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
                        }, theme: getCurrentTheme()
                    )
                    .zIndex(10)
                }

                // Center buttons (Start, Select)
                ForEach(layout.centerButtons, id: \.button.rawValue) { buttonLayout in
                    NESCenterButtonView(
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
                        theme: getCurrentTheme()
                    )
                }
            }
            .ignoresSafeArea()
            .onAppear {
                updateLayout(for: geometry.size)
            }
            .onChange(of: geometry.size) { newSize in
                updateLayout(for: newSize)
            }
            .sheet(isPresented: $showThemePicker) {
                NESThemePickerView(themeManager: themeManager)
            }
        }
        .ignoresSafeArea()
     
        #if DEBUG
       
        #endif
    }
    
}

// Shoulder button component (rectangular shape)
struct NESShoulderButtonView: View {
    let button: NESButtonType
    let layout: NESControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(isPressed ? Color.gray.opacity(0.9) : Color.gray.opacity(0.6))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
            )
            .overlay(
                Text(button.displayName)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            )
            .frame(width: layout.size.width, height: layout.size.height)
            .position(layout.position)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(
                color: isPressed ? .clear : Color.black.opacity(0.3),
                radius: isPressed ? 0 : 4,
                x: 0,
                y: isPressed ? 0 : 2
            )
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
struct NESCenterButtonView: View {
    let button: NESButtonType
    let layout: NESControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void
    let theme: NESControllerTheme

    var body: some View {
        ZStack {
            // Button background image
            Image(buttonImageName)
        }
            .frame(width: layout.size.width, height: layout.size.height)
            .position(layout.position)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(
                color: isPressed ? .clear : Color.black.opacity(0.3),
                radius:isPressed ? 0 : 3,
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

// Preview provider
struct NESControllerView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = NESGameController(name: "NES Custom Controller", systemPrefix: "nes", playerIndex: 0)

        let layout = NESControllerLayout.landscapeLayout(
            screenSize: CGSize(width: 844, height: 390)
        )

        return NESControllerView(controller: controller, layout: layout)
            .previewDevice("iPhone 14 Pro")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
