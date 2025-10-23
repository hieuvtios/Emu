//
//  GenesisButtonView.swift
//  GameEmulator
//
//  SwiftUI button component for Genesis controller
//

import SwiftUI

struct GenesisButtonView: View {
    let button: GenesisButtonType
    let layout: GenesisControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void
    let theme: GenesisControllerTheme

    @State private var touchLocation: CGPoint?

    var body: some View {
        ZStack {
            // Button background image
            Image(buttonImageName)
                .resizable()
                .scaledToFit()
                .opacity(isPressed ? 0.9 : 1.0)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                )
                .shadow(
                    color: isPressed ? .clear : Color.black.opacity(0.3),
                    radius: isPressed ? 0 : 4,
                    x: 0,
                    y: isPressed ? 0 : 2
                )

        }
        .frame(width: layout.size.width, height: layout.size.height)
        .position(layout.position)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if !isPressed {
                        isPressed = true
                        onPress()
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                    touchLocation = value.location
                }
                .onEnded { _ in
                    if isPressed {
                        isPressed = false
                        onRelease()
                    }
                    touchLocation = nil
                }
        )
    }

    private var buttonImageName: String {
        switch button {
        case .a: return theme.buttonAImageName
        case .b: return theme.buttonBImageName
        case .start: return theme.startButtonImageName
        case .c: return theme.buttonCImageName
        case .x: return theme.buttonXImageName
        case .y: return theme.buttonYImageName
        case .z: return theme.buttonZImageName
        default: return "btn-menu-gba"
        }
    }
}

// Center button component (Start/Mode - smaller oval buttons)
struct GenesisCenterButtonView: View {
    let button: GenesisButtonType
    let layout: GenesisControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let theme: GenesisControllerTheme

    let onPress: () -> Void
    let onRelease: () -> Void
    private var buttonImageName: String {
        switch button {
        case .start: return theme.startButtonImageName
        default: return "btn-menu-gba"
        }
    }
    var body: some View {
        Image(buttonImageName)
            .opacity(isPressed ? 0.9 : 1.0)
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
