////
////  GenesisDPadView.swift
////  GameEmulator
////
////  D-Pad component for Genesis controller
////
//
//import SwiftUI
//
//struct GenesisDPadView: View {
//    let layout: GenesisControllerLayout.DPadLayout
//    @Binding var pressedButtons: Set<GenesisButtonType>
//    let onDirectionChange: ([GenesisButtonType]) -> Void
//    let onRelease: () -> Void
//    let theme: GenesisControllerTheme
//
//    @State private var touchLocation: CGPoint?
//
//    init(layout: GenesisControllerLayout.DPadLayout, pressedButtons: Binding<Set<GenesisButtonType>>, onDirectionChange: @escaping ([GenesisButtonType]) -> Void, onRelease: @escaping () -> Void,theme: GenesisControllerTheme) {
//        self.layout = layout
//        self._pressedButtons = pressedButtons
//        self.onDirectionChange = onDirectionChange
//        self.onRelease = onRelease
//        self.theme = theme
//    }
//
//    var body: some View {
//        ZStack {
//            // Background circle
//            Image(theme.dpadImageName)
//            // Touch indicator
//  
//        }
//        .frame(width: layout.radius * 2, height: layout.radius * 2)
//        .frame(width: layout.radius * 2, height: layout.radius * 2)
//        .position(layout.center)
//        .gesture(
//            DragGesture(minimumDistance: 0)
//                .onChanged { value in
//                    handleTouch(at: value.location)
//                }
//                .onEnded { _ in
//                    handleTouchEnd()
//                }
//        )
//    }
//
//
//
//    private func handleTouch(at location: CGPoint) {
//        touchLocation = location
//
//        let frame = CGRect(
//            x: layout.center.x - layout.radius,
//            y: layout.center.y - layout.radius,
//            width: layout.radius * 2,
//            height: layout.radius * 2
//        )
//
//        let newButtons = calculateDPadButtons(at: location, in: frame)
//        let newButtonsSet = Set(newButtons)
//
//        if newButtonsSet != pressedButtons {
//            pressedButtons = newButtonsSet
//            onDirectionChange(newButtons)
//
//            if !newButtons.isEmpty {
//                UIImpactFeedbackGenerator(style: .light).impactOccurred()
//            }
//        }
//    }
//
//    private func calculateDPadButtons(at point: CGPoint, in frame: CGRect) -> [GenesisButtonType] {
//        // Calculate center and vectors
//        let center = CGPoint(x: frame.midX, y: frame.midY)
//        let dx = point.x - center.x
//        let dy = point.y - center.y
//
//        // Dead zone threshold (percentage of radius)
//        let deadZoneThreshold: CGFloat = 0.2
//        let radius = min(frame.width, frame.height) / 2
//        let distance = sqrt(dx * dx + dy * dy)
//
//        guard distance > radius * deadZoneThreshold else {
//            return []
//        }
//
//        // Calculate angle and determine direction
//        let angle = atan2(dy, dx)
//        let degrees = angle * 180 / .pi
//
//        var buttons: [GenesisButtonType] = []
//
//        // 8-directional input with 45-degree sectors
//        if degrees >= -22.5 && degrees < 22.5 {
//            buttons.append(.right)
//        } else if degrees >= 22.5 && degrees < 67.5 {
//            buttons.append(.down)
//            buttons.append(.right)
//        } else if degrees >= 67.5 && degrees < 112.5 {
//            buttons.append(.down)
//        } else if degrees >= 112.5 && degrees < 157.5 {
//            buttons.append(.down)
//            buttons.append(.left)
//        } else if degrees >= 157.5 || degrees < -157.5 {
//            buttons.append(.left)
//        } else if degrees >= -157.5 && degrees < -112.5 {
//            buttons.append(.up)
//            buttons.append(.left)
//        } else if degrees >= -112.5 && degrees < -67.5 {
//            buttons.append(.up)
//        } else if degrees >= -67.5 && degrees < -22.5 {
//            buttons.append(.up)
//            buttons.append(.right)
//        }
//
//        return buttons
//    }
//
//    private func handleTouchEnd() {
//        touchLocation = nil
//        pressedButtons.removeAll()
//        onRelease()
//    }
//}
//
//
