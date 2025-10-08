//
//  GBADPadView.swift
//  GameEmulator
//
//  D-Pad component for GBA controller
//

import SwiftUI

struct GBADPadView: View {
    let layout: GBAControllerLayout.DPadLayout
    @Binding var pressedButtons: Set<GBAButtonType>
    let onDirectionChange: ([GBAButtonType]) -> Void
    let onRelease: () -> Void

    @State private var touchLocation: CGPoint?

    init(layout: GBAControllerLayout.DPadLayout, pressedButtons: Binding<Set<GBAButtonType>>, onDirectionChange: @escaping ([GBAButtonType]) -> Void, onRelease: @escaping () -> Void) {
        self.layout = layout
        self._pressedButtons = pressedButtons
        self.onDirectionChange = onDirectionChange
        self.onRelease = onRelease
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: layout.radius * 2, height: layout.radius * 2)

            // D-Pad shape
            dpadShape
                .fill(Color.gray.opacity(0.6))
                .overlay(
                    dpadShape
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)

            // Direction indicators
            directionIndicators

            // Touch indicator
            if let location = touchLocation {
                Circle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 30, height: 30)
                    .position(location)
            }
        }
        .frame(width: layout.radius * 2, height: layout.radius * 2)
        .position(layout.center)
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

    private var dpadShape: some Shape {
        DPadShape()
    }

    private var directionIndicators: some View {
        ZStack {
            // Up arrow
            Image(systemName: "arrowtriangle.up.fill")
                .font(.system(size: 20))
                .foregroundColor(pressedButtons.contains(.up) ? .white : .white.opacity(0.5))
                .offset(y: -layout.radius * 0.5)

            // Down arrow
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 20))
                .foregroundColor(pressedButtons.contains(.down) ? .white : .white.opacity(0.5))
                .offset(y: layout.radius * 0.5)

            // Left arrow
            Image(systemName: "arrowtriangle.left.fill")
                .font(.system(size: 20))
                .foregroundColor(pressedButtons.contains(.left) ? .white : .white.opacity(0.5))
                .offset(x: -layout.radius * 0.5)

            // Right arrow
            Image(systemName: "arrowtriangle.right.fill")
                .font(.system(size: 20))
                .foregroundColor(pressedButtons.contains(.right) ? .white : .white.opacity(0.5))
                .offset(x: layout.radius * 0.5)
        }
    }

    private func handleTouch(at location: CGPoint) {
        touchLocation = location

        let frame = CGRect(
            x: layout.center.x - layout.radius,
            y: layout.center.y - layout.radius,
            width: layout.radius * 2,
            height: layout.radius * 2
        )

        let newButtons = calculateDPadButtons(at: location, in: frame)
        let newButtonsSet = Set(newButtons)

        if newButtonsSet != pressedButtons {
            pressedButtons = newButtonsSet
            onDirectionChange(newButtons)

            if !newButtons.isEmpty {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }

    private func calculateDPadButtons(at point: CGPoint, in frame: CGRect) -> [GBAButtonType] {
        // Calculate center and vectors
        let center = CGPoint(x: frame.midX, y: frame.midY)
        let dx = point.x - center.x
        let dy = point.y - center.y

        // Dead zone threshold (percentage of radius)
        let deadZoneThreshold: CGFloat = 0.2
        let radius = min(frame.width, frame.height) / 2
        let distance = sqrt(dx * dx + dy * dy)

        guard distance > radius * deadZoneThreshold else {
            return []
        }

        // Calculate angle and determine direction
        let angle = atan2(dy, dx)
        let degrees = angle * 180 / .pi

        var buttons: [GBAButtonType] = []

        // 8-directional input with 45-degree sectors
        if degrees >= -22.5 && degrees < 22.5 {
            buttons.append(.right)
        } else if degrees >= 22.5 && degrees < 67.5 {
            buttons.append(.down)
            buttons.append(.right)
        } else if degrees >= 67.5 && degrees < 112.5 {
            buttons.append(.down)
        } else if degrees >= 112.5 && degrees < 157.5 {
            buttons.append(.down)
            buttons.append(.left)
        } else if degrees >= 157.5 || degrees < -157.5 {
            buttons.append(.left)
        } else if degrees >= -157.5 && degrees < -112.5 {
            buttons.append(.up)
            buttons.append(.left)
        } else if degrees >= -112.5 && degrees < -67.5 {
            buttons.append(.up)
        } else if degrees >= -67.5 && degrees < -22.5 {
            buttons.append(.up)
            buttons.append(.right)
        }

        return buttons
    }

    private func handleTouchEnd() {
        touchLocation = nil
        pressedButtons.removeAll()
        onRelease()
    }
}
