//
//  GBCCenterButtonView.swift
//  GameEmulator
//
//  Created by Hieu Vu on 10/7/25.
//

import SwiftUI

// Center button component (Start/Select - smaller oval buttons)
struct GBCCenterButtonView: View {
    let button: GBCButtonType
    let layout: GBCControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void

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
            return isPressed ? "btn-start-gba" : "btn-start-gba"
        case .select:
            return isPressed ? "btn-select-gba" : "btn-select-gba"
        default:
            return isPressed ? "button_default_pressed" : "button_default"
        }
    }
}
