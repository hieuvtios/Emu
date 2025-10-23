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
    let theme: DSControllerTheme

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

// Shoulder button component (rectangular shape)
struct DSShoulderButtonView: View {
    let button: DSButtonType
    let layout: DSControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let theme: DSControllerTheme
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
    let theme: DSControllerTheme

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
