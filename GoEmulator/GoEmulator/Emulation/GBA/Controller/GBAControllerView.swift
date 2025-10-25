//
//  GBAControllerView.swift
//  GameEmulator
//
//  Main GBA controller view with direct mGBA integration
//  Authentic Game Boy Advance layout
//

import SwiftUI

struct GBAControllerView: View {
    let controller: GBADirectController
    let onMenuButtonTap: () -> Void

    @State private var buttonStates: [GBAButtonType: Bool] = [:]
    @State private var dpadButtons: Set<GBAButtonType> = []
    @State private var currentLayout: GBAControllerLayoutDefinition?

    #if DEBUG
    @StateObject private var themeManager = GBAThemeManager()
    @State private var showThemePicker = false
    #endif

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // MARK: - Main Controller Area
                ZStack(alignment: .bottom) {
                    // Background - only in portrait mode
                    // In landscape, background is handled by UIKit layer below game view
                    if geometry.size.width > geometry.size.height {
                        Color.clear
                            .ignoresSafeArea()
                    } else {
                        ZStack(alignment: .top) {
                            Image(getCurrentTheme().backgroundPortraitImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                                .clipped()
                            HStack(alignment: .top) {
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

                    if let layout = currentLayout {
                        let isLandscape = geometry.size.width > geometry.size.height

                        // D-Pad
                        GBADPadView(
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
                            },
                            theme: getCurrentTheme()
                        )
                        .opacity(isLandscape ? 0.8 : 1.0)
                        .zIndex(1)

                        // Action Buttons
                        ForEach(layout.actionButtons, id: \.button.rawValue) { buttonLayout in
                            GBAButtonView(
                                button: buttonLayout.button,
                                layout: buttonLayout,
                                isPressed: Binding(
                                    get: { buttonStates[buttonLayout.button] ?? false },
                                    set: { buttonStates[buttonLayout.button] = $0 }
                                ),
                                onPress: { controller.pressButton(buttonLayout.button) },
                                onRelease: { controller.releaseButton(buttonLayout.button) },
                                theme: getCurrentTheme()
                            )
                            .opacity(isLandscape ? 0.8 : 1.0)
                            .zIndex(2)
                        }

                        // Shoulder buttons (L, R)
                        ForEach(layout.shoulderButtons, id: \.button.rawValue) { buttonLayout in
                            GBAShoulderButtonView(
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
                            .opacity(isLandscape ? 0.8 : 1.0)
                            .zIndex(2)
                        }

                        // Center Buttons (Start, Select)
                        ForEach(layout.centerButtons, id: \.button.rawValue) { buttonLayout in
                            GBACenterButtonView(
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
                            .opacity(isLandscape ? 0.8 : 1.0)
                            .zIndex(2)
                        }

                        // Menu Button
                        if let firstCenterButton = layout.centerButtons.first {
                            let isLandscape = geometry.size.width > geometry.size.height
                            Button(action: {
                                onMenuButtonTap()
                            }) {
                                Image(getCurrentTheme().menuButtonImageName)
                            }
                            .position(x: isLandscape ? 50 : 30, y: firstCenterButton.position.y)
                            .zIndex(3)
                        }

                        #if DEBUG
                        // Theme Picker Button (Debug Only)
                        Button(action: {
                            showThemePicker = true
                        }) {
                            Image(systemName: "paintbrush.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Circle().fill(Color.blue.opacity(0.8)))
                                .shadow(radius: 4)
                        }
                        .position(x: geometry.size.width - 40, y: 40)
                        .zIndex(3)
                        #endif
                    }
                }
                .ignoresSafeArea()
            }
            .ignoresSafeArea()
            .onAppear {
                updateLayout(for: geometry.size)
            }
            .onChange(of: geometry.size) { newSize in
                updateLayout(for: newSize)
            }
            #if DEBUG
            .sheet(isPresented: $showThemePicker) {
                GBAThemePickerView(themeManager: themeManager)
            }
            #endif
        }
    }

    // MARK: - Layout Update

    private func updateLayout(for size: CGSize) {
        // Determine orientation based on aspect ratio
        let isLandscape = size.width > size.height

        // Update layout based on orientation
        if isLandscape {
            currentLayout = GBAControllerLayout.landscapeLayout(screenSize: size)
        } else {
            currentLayout = GBAControllerLayout.portraitLayout(screenSize: size)
        }
    }

    // MARK: - Theme Helper

    private func getCurrentTheme() -> GBAControllerTheme {
        #if DEBUG
        return themeManager.currentTheme
        #else
        return .defaultTheme
        #endif
    }
}


// Shoulder button component (using N64 L/R button images)
struct GBAShoulderButtonView: View {
    let button: GBAButtonType
    let layout: GBAControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void
    let theme: GBAControllerTheme

    private var buttonImageName: String {
        switch button {
        case .l:
            return theme.leftButtonImageName
        case .r:
            return theme.rightButtonImageName
        default:
            return theme.leftButtonImageName
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
                    if !isPressed {
                        isPressed = false
                        onRelease()
                    }
                }
        )
    }
}

// Center button component (Start/Select - using images from GBC)
struct GBACenterButtonView: View {
    let button: GBAButtonType
    let layout: GBAControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void
    let theme: GBAControllerTheme

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

// Preview provider
struct GBAControllerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Portrait Preview
            GBAControllerView(
                controller: GBADirectController(name: "Preview Controller"),
                onMenuButtonTap: { print("Menu tapped") }
            )
                .previewDisplayName("Portrait")
                .previewInterfaceOrientation(.portrait)

            // Landscape Preview
            GBAControllerView(
                controller: GBADirectController(name: "Preview Controller"),
                onMenuButtonTap: { print("Menu tapped") }
            )
                .previewDisplayName("Landscape")
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}


