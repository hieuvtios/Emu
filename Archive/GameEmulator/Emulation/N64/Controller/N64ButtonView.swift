//
//  N64ButtonView.swift
//  GameEmulator
//
//  SwiftUI button component for N64 controller
//

import SwiftUI

struct N64ButtonView: View {
    let button: N64ButtonType
    let layout: N64ControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void
    let theme: N64ControllerTheme
    @State private var touchLocation: CGPoint?
    private var buttonImageName: String {
        switch button {
        case .a: return theme.buttonAImageName
        case .b: return theme.buttonBImageName
        case .start: return theme.startButtonImageName
        case .z: return theme.zButtonImageGreenName
        default: return "btn-menu-gba"
        }
    }
    var body: some View {
        ZStack {
            // Button background - N64 style
            Image(buttonImageName)
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

    private var buttonColor: Color {
        switch button {
        case .a:
            // N64 A button - Blue
            return isPressed ? Color(red: 0.2, green: 0.4, blue: 0.9).opacity(0.9) : Color(red: 0.2, green: 0.4, blue: 0.9).opacity(0.7)
        case .b:
            // N64 B button - Green
            return isPressed ? Color(red: 0.2, green: 0.8, blue: 0.3).opacity(0.9) : Color(red: 0.2, green: 0.8, blue: 0.3).opacity(0.7)
        case .l, .r:
            // Shoulder buttons - Gray
            return isPressed ? Color.gray.opacity(0.9) : Color.gray.opacity(0.6)
        case .z:
            // Z trigger - Dark gray
            return isPressed ? Color(white: 0.3).opacity(0.9) : Color(white: 0.3).opacity(0.7)
        case .start:
            // Start - Red
            return isPressed ? Color.red.opacity(0.8) : Color.red.opacity(0.6)
        default:
            return isPressed ? Color.gray.opacity(0.9) : Color.gray.opacity(0.7)
        }
    }
}

// Shoulder button component (rectangular shape)
struct N64ShoulderButtonView: View {
    let button: N64ButtonType
    let layout: N64ControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let theme: N64ControllerTheme
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

// Z button component (smaller rectangular trigger)
struct N64ZButtonView: View {
    let layout: N64ControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void
    let theme: N64ControllerTheme
    var body: some View {
        ZStack {
            // Button background image
            Image(theme.zButtonImageName)
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

// Start button component
struct N64StartButtonView: View {
    let layout: N64ControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void

    var body: some View {
        Capsule()
            .fill(isPressed ? Color.red.opacity(0.8) : Color.red.opacity(0.6))
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
            )
            .overlay(
                Text("Start")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
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
