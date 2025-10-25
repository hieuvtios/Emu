//
//  GBAButtonView.swift
//  GameEmulator
//
//  SwiftUI button component for GBA controller
//

import SwiftUI

struct GBAButtonView: View {
    let button: GBAButtonType
    let layout: GBAControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void
    let theme: GBAControllerTheme

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

    // MARK: - Helpers

    private var buttonImageName: String {
        switch button {
        case .a: return theme.buttonAImageName
        case .b: return theme.buttonBImageName
        default: return "btn-menu-gba"
        }
    }
}
