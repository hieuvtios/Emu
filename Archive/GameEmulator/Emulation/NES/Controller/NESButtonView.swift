//
//  NESButtonView.swift
//  GameEmulator
//
//  SwiftUI button component for NES controller
//

import SwiftUI

struct NESButtonView: View {
    let button: NESButtonType
    let layout: NESControllerLayout.ButtonLayout
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void
    let theme: NESControllerTheme

    @State private var touchLocation: CGPoint?
    private var buttonImageName: String {
        switch button {
        case .a: return theme.buttonAImageName
        case .b: return theme.buttonBImageName
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

    private var buttonColor: Color {
        switch button {
        case .a:
            return isPressed ? Color.red.opacity(0.9) : Color.red.opacity(0.7)
        case .b:
            return isPressed ? Color.yellow.opacity(0.9) : Color.yellow.opacity(0.7)
//        case .x:
//            return isPressed ? Color.blue.opacity(0.9) : Color.blue.opacity(0.7)
//        case .y:
//            return isPressed ? Color.green.opacity(0.9) : Color.green.opacity(0.7)
//        case .l, .r:
//            return isPressed ? Color.gray.opacity(0.9) : Color.gray.opacity(0.6)
        case .start, .select:
            return isPressed ? Color.gray.opacity(0.8) : Color.gray.opacity(0.5)
        default:
            return isPressed ? Color.gray.opacity(0.9) : Color.gray.opacity(0.7)
        }
    }
}
