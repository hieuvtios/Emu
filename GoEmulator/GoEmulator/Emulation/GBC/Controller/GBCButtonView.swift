////
////  GBCButtonView.swift
////  GameEmulator
////
////  SwiftUI button component for GBC controller
////
//
//import SwiftUI
//struct GBCButtonView: View {
//    let button: GBCButtonType
//    let layout: GBCControllerLayout.ButtonLayout
//    @Binding var isPressed: Bool
//    let onPress: () -> Void
//    let onRelease: () -> Void
//    let theme: GBCControllerTheme
//
//    @State private var touchLocation: CGPoint?
//
//    var body: some View {
//        ZStack {
//            // Button background image
//            Image(buttonImageName)
//                .resizable()
//                .scaledToFit()
//                .opacity(isPressed ? 0.9 : 1.0)
//                .overlay(
//                    Circle()
//                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
//                )
//                .shadow(
//                    color: isPressed ? .clear : Color.black.opacity(0.3),
//                    radius: isPressed ? 0 : 4,
//                    x: 0,
//                    y: isPressed ? 0 : 2
//                )
//
//            // Optional text label (if you want to show the letter)
////            if button.showLabel {
////                Text(button.displayName)
////                    .font(.system(size: 18, weight: .bold, design: .rounded))
////                    .foregroundColor(.white)
////                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
////            }
//        }
//        .frame(width: layout.size.width, height: layout.size.height)
//        .position(layout.position)
////        .scaleEffect(isPressed ? 0.95 : 1.0)
////        .animation(.easeInOut(duration: 0.1), value: isPressed)
//        .gesture(
//            DragGesture(minimumDistance: 0)
//                .onChanged { value in
//                    if !isPressed {
//                        isPressed = true
//                        onPress()
//                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//                    }
//                    touchLocation = value.location
//                }
//                .onEnded { _ in
//                    if isPressed {
//                        isPressed = false
//                        onRelease()
//                    }
//                    touchLocation = nil
//                }
//        )
//    }
//
//    // MARK: - Helpers
//
//    private var buttonImageName: String {
//        switch button {
//        case .a: return theme.buttonAImageName
//        case .b: return theme.buttonBImageName
//        case .start: return theme.startButtonImageName
//        case .select: return theme.selectButtonImageName
//        default: return "btn-menu-gba"
//        }
//    }
//}
////struct GBCButtonView: View {
////    let button: GBCButtonType
////    let layout: GBCControllerLayout.ButtonLayout
////    @Binding var isPressed: Bool
////    let onPress: () -> Void
////    let onRelease: () -> Void
////
////    @State private var touchLocation: CGPoint?
////
////    var body: some View {
////        ZStack {
////            // Button background
////            Circle()
////                .fill(buttonColor)
////                .overlay(
////                    Circle()
////                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
////                )
////                .shadow(
////                    color: isPressed ? .clear : Color.black.opacity(0.3),
////                    radius: isPressed ? 0 : 4,
////                    x: 0,
////                    y: isPressed ? 0 : 2
////                )
////
////            // Button label
////            Text(button.displayName)
////                .font(.system(size: 18, weight: .bold, design: .rounded))
////                .foregroundColor(.white)
////                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
////        }
////        .frame(width: layout.size.width, height: layout.size.height)
////        .position(layout.position)
////        .scaleEffect(isPressed ? 0.95 : 1.0)
////        .animation(.easeInOut(duration: 0.1), value: isPressed)
////        .gesture(
////            DragGesture(minimumDistance: 0)
////                .onChanged { value in
////                    if !isPressed {
////                        isPressed = true
////                        onPress()
////                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
////                    }
////                    touchLocation = value.location
////                }
////                .onEnded { _ in
////                    if isPressed {
////                        isPressed = false
////                        onRelease()
////                    }
////                    touchLocation = nil
////                }
////        )
////    }
////
////    private var buttonColor: Color {
////        switch button {
////        case .a:
////            return isPressed ? Color.red.opacity(0.9) : Color.red.opacity(0.7)
////        case .b:
////            return isPressed ? Color.blue.opacity(0.9) : Color.blue.opacity(0.7)
////        case .start, .select:
////            return isPressed ? Color.gray.opacity(0.8) : Color.gray.opacity(0.5)
////        default:
////            return isPressed ? Color.gray.opacity(0.9) : Color.gray.opacity(0.7)
////        }
////    }
////}
//
