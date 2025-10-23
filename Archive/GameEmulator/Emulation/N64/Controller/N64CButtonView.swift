//
//  N64CButtonView.swift
//  GameEmulator
//
//  C-Button cluster component for N64 controller
//  Unique to N64 - 4 yellow buttons arranged in cross pattern
//

import SwiftUI

struct N64CButtonView: View {
    let layout: N64ControllerLayout.CButtonLayout
    @Binding var pressedButtons: Set<N64ButtonType>
    let onPress: (N64ButtonType) -> Void
    let onRelease: (N64ButtonType) -> Void

    @State private var touchLocation: CGPoint?
    @State private var activeButton: N64ButtonType?

    var body: some View {
        ZStack {
            // Background circle for C-button cluster
            Image(.btnN64DpadCircle)
                .frame(width: layout.spacing * 2.2, height: layout.spacing * 2.2)
                .position(layout.center)

//            // C-Up
//            cButtonShape(for: .cUp)
//                .fill(buttonColor(for: .cUp))
//                .frame(width: layout.buttonSize.width, height: layout.buttonSize.height)
//                .overlay(
//                    cButtonShape(for: .cUp)
//                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
//                        .frame(width: layout.buttonSize.width, height: layout.buttonSize.height)
//                )
//                .overlay(
//                    Image(systemName: "arrowtriangle.up.fill")
//                        .font(.system(size: 14))
//                        .foregroundColor(.white)
//                )
//                .scaleEffect(pressedButtons.contains(.cUp) ? 0.95 : 1.0)
//                .position(cButtonPosition(for: .cUp))
//                .shadow(
//                    color: pressedButtons.contains(.cUp) ? .clear : Color.black.opacity(0.3),
//                    radius: pressedButtons.contains(.cUp) ? 0 : 3,
//                    x: 0,
//                    y: pressedButtons.contains(.cUp) ? 0 : 1
//                )
//
//            // C-Down
//            cButtonShape(for: .cDown)
//                .fill(buttonColor(for: .cDown))
//                .frame(width: layout.buttonSize.width, height: layout.buttonSize.height)
//                .overlay(
//                    cButtonShape(for: .cDown)
//                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
//                        .frame(width: layout.buttonSize.width, height: layout.buttonSize.height)
//                )
//                .overlay(
//                    Image(systemName: "arrowtriangle.down.fill")
//                        .font(.system(size: 14))
//                        .foregroundColor(.white)
//                )
//                .scaleEffect(pressedButtons.contains(.cDown) ? 0.95 : 1.0)
//                .position(cButtonPosition(for: .cDown))
//                .shadow(
//                    color: pressedButtons.contains(.cDown) ? .clear : Color.black.opacity(0.3),
//                    radius: pressedButtons.contains(.cDown) ? 0 : 3,
//                    x: 0,
//                    y: pressedButtons.contains(.cDown) ? 0 : 1
//                )
//
//            // C-Left
//            cButtonShape(for: .cLeft)
//                .fill(buttonColor(for: .cLeft))
//                .frame(width: layout.buttonSize.width, height: layout.buttonSize.height)
//                .overlay(
//                    cButtonShape(for: .cLeft)
//                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
//                        .frame(width: layout.buttonSize.width, height: layout.buttonSize.height)
//                )
//                .overlay(
//                    Image(systemName: "arrowtriangle.left.fill")
//                        .font(.system(size: 14))
//                        .foregroundColor(.white)
//                )
//                .scaleEffect(pressedButtons.contains(.cLeft) ? 0.95 : 1.0)
//                .position(cButtonPosition(for: .cLeft))
//                .shadow(
//                    color: pressedButtons.contains(.cLeft) ? .clear : Color.black.opacity(0.3),
//                    radius: pressedButtons.contains(.cLeft) ? 0 : 3,
//                    x: 0,
//                    y: pressedButtons.contains(.cLeft) ? 0 : 1
//                )
//
//            // C-Right
//            cButtonShape(for: .cRight)
//                .fill(buttonColor(for: .cRight))
//                .frame(width: layout.buttonSize.width, height: layout.buttonSize.height)
//                .overlay(
//                    cButtonShape(for: .cRight)
//                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
//                        .frame(width: layout.buttonSize.width, height: layout.buttonSize.height)
//                )
//                .overlay(
//                    Image(systemName: "arrowtriangle.right.fill")
//                        .font(.system(size: 14))
//                        .foregroundColor(.white)
//                )
//                .scaleEffect(pressedButtons.contains(.cRight) ? 0.95 : 1.0)
//                .position(cButtonPosition(for: .cRight))
//                .shadow(
//                    color: pressedButtons.contains(.cRight) ? .clear : Color.black.opacity(0.3),
//                    radius: pressedButtons.contains(.cRight) ? 0 : 3,
//                    x: 0,
//                    y: pressedButtons.contains(.cRight) ? 0 : 1
//                )

       
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    handleTouch(at: value.location)
                }
                .onEnded { _ in
                    handleTouchEnd()
                }
        )
    }

    private func cButtonShape(for button: N64ButtonType) -> some Shape {
        return RoundedRectangle(cornerRadius: 6)
    }

    private func cButtonPosition(for button: N64ButtonType) -> CGPoint {
        switch button {
        case .cUp:
            return CGPoint(x: layout.center.x, y: layout.center.y - layout.spacing)
        case .cDown:
            return CGPoint(x: layout.center.x, y: layout.center.y + layout.spacing)
        case .cLeft:
            return CGPoint(x: layout.center.x - layout.spacing, y: layout.center.y)
        case .cRight:
            return CGPoint(x: layout.center.x + layout.spacing, y: layout.center.y)
        default:
            return layout.center
        }
    }

    private func buttonColor(for button: N64ButtonType) -> Color {
        // N64 C-buttons are yellow
        let baseColor = Color(red: 1.0, green: 0.85, blue: 0.0)
        return pressedButtons.contains(button) ? baseColor.opacity(0.9) : baseColor.opacity(0.7)
    }

    private func handleTouch(at location: CGPoint) {
        touchLocation = location

        // Determine which C-button is being touched
        let touchedButton = findTouchedCButton(at: location)

        if let button = touchedButton {
            if activeButton != button {
                // Release previous button if different
                if let prevButton = activeButton {
                    pressedButtons.remove(prevButton)
                    onRelease(prevButton)
                }

                // Press new button
                pressedButtons.insert(button)
                activeButton = button
                onPress(button)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        } else {
            // Touch is outside any button
            if let prevButton = activeButton {
                pressedButtons.remove(prevButton)
                onRelease(prevButton)
                activeButton = nil
            }
        }
    }

    private func findTouchedCButton(at location: CGPoint) -> N64ButtonType? {
        let buttons: [N64ButtonType] = [.cUp, .cDown, .cLeft, .cRight]

        for button in buttons {
            let buttonPos = cButtonPosition(for: button)
            let dx = location.x - buttonPos.x
            let dy = location.y - buttonPos.y
            let distance = sqrt(dx * dx + dy * dy)

            // Check if touch is within button bounds (using diagonal of rect)
            let threshold = sqrt(pow(layout.buttonSize.width, 2) + pow(layout.buttonSize.height, 2)) / 2
            if distance < threshold {
                return button
            }
        }

        return nil
    }

    private func handleTouchEnd() {
        touchLocation = nil

        // Release active button
        if let button = activeButton {
            pressedButtons.remove(button)
            onRelease(button)
            activeButton = nil
        }
    }
}
