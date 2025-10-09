//
//  DSButtonView.swift
//  GameEmulator
//
//  Button component for Nintendo DS controller
//

import SwiftUI

struct DSButtonView: View {
    let button: DSButtonType
    let layout: DSControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void

    var body: some View {
        Circle()
            .fill(buttonColor)
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.4), lineWidth: 2.5)
            )
            .overlay(
                Text(button.displayName)
                    .font(.system(size: buttonFontSize, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
            )
            .frame(width: layout.size.width, height: layout.size.height)
            .position(layout.position)
            .scaleEffect(isPressed ? 0.92 : 1.0)
            .shadow(
                color: isPressed ? .clear : Color.black.opacity(0.35),
                radius: isPressed ? 0 : 5,
                x: 0,
                y: isPressed ? 0 : 3
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

    private var buttonColor: Color {
        if isPressed {
            switch button {
            case .a: return Color.red.opacity(0.85)
            case .b: return Color.yellow.opacity(0.85)
            case .x: return Color.blue.opacity(0.85)
            case .y: return Color.green.opacity(0.85)
            default: return Color.gray.opacity(0.85)
            }
        } else {
            switch button {
            case .a: return Color.red.opacity(0.6)
            case .b: return Color.yellow.opacity(0.6)
            case .x: return Color.blue.opacity(0.6)
            case .y: return Color.green.opacity(0.6)
            default: return Color.gray.opacity(0.6)
            }
        }
    }

    private var buttonFontSize: CGFloat {
        return layout.size.width * 0.35
    }
}

// Shoulder button component (rectangular shape)
struct DSShoulderButtonView: View {
    let button: DSButtonType
    let layout: DSControllerLayout.ButtonLayout
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
struct DSCenterButtonView: View {
    let button: DSButtonType
    let layout: DSControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void

    var body: some View {
        Capsule()
            .fill(isPressed ? Color.gray.opacity(0.8) : Color.gray.opacity(0.5))
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
            )
            .overlay(
                Text(button.displayName)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            )
            .frame(width: layout.size.width, height: layout.size.height)
            .position(layout.position)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(
                color: isPressed ? .clear : Color.black.opacity(0.3),
                radius: isPressed ? 0 : 3,
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
}
