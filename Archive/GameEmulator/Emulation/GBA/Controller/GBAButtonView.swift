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

    @State private var touchLocation: CGPoint?

    var body: some View {
        ZStack {
            // Button background - GBA style pill shape
            Capsule()
                .fill(buttonColor)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
                .shadow(
                    color: isPressed ? .clear : Color.black.opacity(0.3),
                    radius: isPressed ? 0 : 4,
                    x: 0,
                    y: isPressed ? 0 : 2
                )

            // Button label
            Text(button.displayName)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
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

    private var buttonColor: Color {
        switch button {
        case .a:
            // GBA A button - Red/pink color
            return isPressed ? Color(red: 0.9, green: 0.2, blue: 0.3).opacity(0.9) : Color(red: 0.9, green: 0.2, blue: 0.3).opacity(0.7)
        case .b:
            // GBA B button - Beige/tan color
            return isPressed ? Color(red: 0.9, green: 0.8, blue: 0.6).opacity(0.9) : Color(red: 0.9, green: 0.8, blue: 0.6).opacity(0.7)
        case .l, .r:
            return isPressed ? Color.gray.opacity(0.9) : Color.gray.opacity(0.6)
        case .start, .select:
            return isPressed ? Color.gray.opacity(0.8) : Color.gray.opacity(0.5)
        default:
            return isPressed ? Color.gray.opacity(0.9) : Color.gray.opacity(0.7)
        }
    }
}
