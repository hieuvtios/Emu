//
//  N64AnalogStickView.swift
//  GameEmulator
//
//  Analog stick component for N64 controller
//  Provides continuous 2D input for movement control
//

import SwiftUI

struct N64AnalogStickView: View {
    let layout: N64ControllerLayout.AnalogStickLayout
    let onPositionChange: (CGFloat, CGFloat) -> Void
    let onRelease: () -> Void
    let theme: N64ControllerTheme

    @State private var thumbOffset: CGSize = .zero
    @State private var isDragging: Bool = false

    // Dead zone threshold (percentage of radius where no input is registered)
    private let deadZoneThreshold: CGFloat = 0.15

    var body: some View {
        ZStack {
            // Outer boundary circle (base)
            Image(theme.analogStickBaseImageName)
                .resizable()
                .frame(width: layout.radius * 2, height: layout.radius * 2)

            // Inner thumbstick (draggable)
            Image(theme.analogStickThumbImageName)
                .resizable()
                .frame(width: layout.thumbRadius * 2, height: layout.thumbRadius * 2)
                .offset(thumbOffset)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            handleDrag(value: value)
                        }
                        .onEnded { _ in
                            handleDragEnd()
                        }
                )
        }
        .frame(width: layout.radius * 2, height: layout.radius * 2)
        .position(layout.center)
    }

    private func handleDrag(value: DragGesture.Value) {
        isDragging = true

        // Calculate offset from center
        var newOffset = value.translation

        // Calculate distance from center
        let distance = sqrt(newOffset.width * newOffset.width + newOffset.height * newOffset.height)

        // Constrain to circle boundary (minus thumb radius for visual correctness)
        let maxDistance = layout.radius - layout.thumbRadius
        if distance > maxDistance {
            let ratio = maxDistance / distance
            newOffset.width *= ratio
            newOffset.height *= ratio
        }

        thumbOffset = newOffset

        // Calculate normalized position (-1.0 to 1.0)
        let normalizedX = newOffset.width / maxDistance
        let normalizedY = newOffset.height / maxDistance

        // Apply dead zone
        let normalizedDistance = sqrt(normalizedX * normalizedX + normalizedY * normalizedY)
        if normalizedDistance < deadZoneThreshold {
            // Within dead zone - report no movement
            onPositionChange(0, 0)
        } else {
            // Outside dead zone - report position
            onPositionChange(normalizedX, normalizedY)

            // Haptic feedback on first movement outside dead zone
            if !isDragging || thumbOffset == .zero {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }

    private func handleDragEnd() {
        isDragging = false

        // Snap back to center with animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            thumbOffset = .zero
        }

        // Report release
        onRelease()
    }
}

// Layout definition for analog stick
extension N64ControllerLayout {
    struct AnalogStickLayout {
        let center: CGPoint
        let radius: CGFloat
        let thumbRadius: CGFloat
    }
}
