//
//  SNESDPadView.swift
//  GameEmulator
//
//  D-Pad component for SNES controller
//

import SwiftUI

struct SNESDPadView: View {
    let layout: SNESControllerLayout.DPadLayout
    @Binding var pressedButtons: Set<SNESButtonType>
    let onDirectionChange: ([SNESButtonType]) -> Void
    let onRelease: () -> Void
    let theme: SNESControllerTheme

    @State private var touchLocation: CGPoint?

    init(layout: SNESControllerLayout.DPadLayout, pressedButtons: Binding<Set<SNESButtonType>>, onDirectionChange: @escaping ([SNESButtonType]) -> Void, onRelease: @escaping () -> Void,theme: SNESControllerTheme) {
        self.layout = layout
        self._pressedButtons = pressedButtons
        self.onDirectionChange = onDirectionChange
        self.onRelease = onRelease
        self.theme = theme
    }

    var body: some View {
        ZStack {
            // Background circle
            Image(theme.dpadImageName)
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

    private func calculateDPadButtons(at point: CGPoint, in frame: CGRect) -> [SNESButtonType] {
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

        var buttons: [SNESButtonType] = []

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

// Custom D-Pad shape (cross/plus shape)
struct DPadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height
        let armWidth = width * 0.35
        let armHeight = height * 0.35

        // Horizontal bar
        path.addRoundedRect(
            in: CGRect(
                x: 0,
                y: (height - armHeight) / 2,
                width: width,
                height: armHeight
            ),
            cornerSize: CGSize(width: 5, height: 5)
        )

        // Vertical bar
        path.addRoundedRect(
            in: CGRect(
                x: (width - armWidth) / 2,
                y: 0,
                width: armWidth,
                height: height
            ),
            cornerSize: CGSize(width: 5, height: 5)
        )

        return path
    }
}
