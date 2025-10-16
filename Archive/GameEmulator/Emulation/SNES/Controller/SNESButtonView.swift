//
//  SNESButtonView.swift
//  GameEmulator
//
//  SwiftUI button component for SNES controller
//

import SwiftUI

struct SNESButtonView: View {
    let button: SNESButtonType
    let layout: SNESControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void
    let theme: SNESControllerTheme

    @State private var touchLocation: CGPoint?
    private var buttonImageName: String {
        switch button {
        case .a: return theme.buttonAImageName
        case .b: return theme.buttonBImageName
        case .y: return theme.buttonYImageName
        case .x: return theme.buttonXImageName
        case .start: return theme.startButtonImageName
        case .select: return theme.selectButtonImageName
        default: return "btn-menu-gba"
        }
    }
    var body: some View {
        ZStack {
            // Button background
            Image(buttonImageName)
                .resizable()
                .scaledToFit()
                .opacity(isPressed ? 0.9 : 1.0)
        }
        .frame(width: layout.size.width, height: layout.size.height)
        .position(layout.position)
        .scaleEffect(isPressed ? 0.95 : 1.0)
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
}
