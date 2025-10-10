import SwiftUI

struct GBCControllerView: View {
    let controller: GBCDirectController

    @State private var buttonStates: [GBCButtonType: Bool] = [:]
    @State private var dpadButtons: Set<GBCButtonType> = []
    @State private var currentLayout: GBCControllerLayoutDefinition?

    #if DEBUG
    @StateObject private var themeManager = GBCThemeManager()
    @State private var showThemePicker = false
    #endif

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // MARK: - Main Controller Area
                ZStack(alignment:.bottom) {
                    // Background
                    if geometry.size.width > geometry.size.height {
                        Image(getCurrentTheme().backgroundLandscapeImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .ignoresSafeArea()
                    } else {
                        ZStack(alignment:.top){
                          Image(getCurrentTheme().backgroundPortraitImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                                .clipped()
                            HStack(alignment:.top) {
                                Image(.btnLeft)
                                    .aspectRatio(contentMode: .fit)
                                    .offset(CGSizeMake(0, -7))
                                Spacer()
                                Image(.btnRight)
                                    .aspectRatio(contentMode: .fit)
                                    .offset(CGSizeMake(0, -7))

                            }
                            .frame(maxWidth: .infinity, alignment: .top)
                        }


                    }
               

                    if let layout = currentLayout {
                        // D-Pad
                        GBCDPadView(
                            layout: layout.dpad,
                            pressedButtons: $dpadButtons,
                            onDirectionChange: { buttons in
                                controller.releaseAllDPadButtons()
                                if !buttons.isEmpty {
                                    controller.pressDPadButtons(buttons)
                                }
                            },
                            onRelease: {
                                controller.releaseAllDPadButtons()
                            },
                            theme: getCurrentTheme()
                        )
                        .zIndex(1)

                        // Action Buttons
                        ForEach(layout.actionButtons, id: \.button.rawValue) { buttonLayout in
                            GBCButtonView(
                                button: buttonLayout.button,
                                layout: buttonLayout,
                                isPressed: Binding(
                                    get: { buttonStates[buttonLayout.button] ?? false },
                                    set: { buttonStates[buttonLayout.button] = $0 }
                                ),
                                onPress: { controller.pressButton(buttonLayout.button) },
                                onRelease: { controller.releaseButton(buttonLayout.button) },
                                theme: getCurrentTheme()
                            )
                        }

                        // Center Buttons (Start, Select)
                        ForEach(layout.centerButtons, id: \.button.rawValue) { buttonLayout in
                            GBCCenterButtonView(
                                button: buttonLayout.button,
                                layout: buttonLayout,
                                isPressed: Binding(
                                    get: { buttonStates[buttonLayout.button] ?? false },
                                    set: { buttonStates[buttonLayout.button] = $0 }
                                ),
                                onPress: {
                                    controller.pressButton(buttonLayout.button)
                                },
                                onRelease: {
                                    controller.releaseButton(buttonLayout.button)
                                },
                                theme: getCurrentTheme()
                            )
                        }

                        #if DEBUG
                        // Theme Picker Button (Debug Only)
                        Button(action: {
                            showThemePicker = true
                        }) {
                            Image(systemName: "paintbrush.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Circle().fill(Color.blue.opacity(0.8)))
                                .shadow(radius: 4)
                        }
                        .position(x: geometry.size.width - 40, y: 40)
                        .zIndex(1)
                        #endif
                    }
                }
                .ignoresSafeArea()

                // MARK: - Bottom Black Bar
//                Rectangle()
//                    .fill(Color.black)
//                    .frame(height: 60)
//                    .ignoresSafeArea(edges: .bottom)
            }
            .ignoresSafeArea()
            .onAppear {
                updateLayout(for: geometry.size)
            }
            .onChange(of: geometry.size) { newSize in
                updateLayout(for: newSize)
            }
            #if DEBUG
            .sheet(isPresented: $showThemePicker) {
                GBCThemePickerView(themeManager: themeManager)
            }
            #endif
        }
    }

    // MARK: - Layout Update

    private func updateLayout(for size: CGSize) {
        // Determine orientation based on aspect ratio
        let isLandscape = size.width > size.height

        // Update layout based on orientation
        if isLandscape {
            currentLayout = GBCControllerLayout.landscapeLayout(screenSize: size)
        } else {
            currentLayout = GBCControllerLayout.portraitLayout(screenSize: size)
        }
    }

    // MARK: - Theme Helper

    private func getCurrentTheme() -> GBCControllerTheme {
        #if DEBUG
        return themeManager.currentTheme
        #else
        return .defaultTheme
        #endif
    }
}
// Preview this view
struct GBCControllerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Portrait Preview
            GBCControllerView(controller: GBCDirectController(name: "Preview Controller"))
                .previewDisplayName("Portrait")
                .previewInterfaceOrientation(.portrait)
            
            // Landscape Preview
            GBCControllerView(controller: GBCDirectController(name: "Preview Controller"))
                .previewDisplayName("Landscape")
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
struct GBCControllerLayout {

    // MARK: - Layout Constants

    enum LayoutMode {
        case landscape
        case portrait
    }

    struct ButtonLayout {
        let position: CGPoint
        let size: CGSize
        let button: GBCButtonType
    }

    struct DPadLayout {
        let center: CGPoint
        let radius: CGFloat
    }

    // MARK: - Landscape Layout

    static func landscapeLayout(screenSize: CGSize) -> GBCControllerLayoutDefinition {
        let baseWidth: CGFloat = 852
        let baseHeight: CGFloat = 393

        let widthRatio = screenSize.width / baseWidth
        let heightRatio = screenSize.height / baseHeight

        let buttonSize = CGSize(width: 55 * heightRatio, height: 55 * heightRatio)
        let dpadRadius: CGFloat = 60 * heightRatio
        let smallButtonSize = CGSize(width: 45 * heightRatio, height: 20 * heightRatio)

        // D-Pad (bottom-left corner)
        let dpadCenter = CGPoint(
            x: screenSize.width * 0.2,
            y: screenSize.height * 0.75
        )

        // Action buttons (right side, stacked vertically with slight offset)
        // A button (red) - top right
        // B button (yellow) - below and slightly left of A
        let actionButtonsBaseX = screenSize.width * 0.95
        let actionButtonsBaseY = screenSize.height * 0.68
        let verticalSpacing: CGFloat = 70 * heightRatio

        let actionButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsBaseX,
                    y: actionButtonsBaseY
                ),
                size: buttonSize,
                button: .a
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsBaseX - 50 * widthRatio,
                    y: actionButtonsBaseY + verticalSpacing
                ),
                size: buttonSize,
                button: .b
            )
        ]

        // Center Buttons (Select/Start) - positioned below the screen area
        let centerButtonsY = screenSize.height * 0.90
        let centerSpacing = 80 * widthRatio

        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 ,
                    y: centerButtonsY
                ),
                size: smallButtonSize,
                button: .select
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + 80,
                    y: centerButtonsY
                ),
                size: smallButtonSize,
                button: .start
            )
        ]

        return GBCControllerLayoutDefinition(
            mode: .landscape,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            centerButtons: centerButtons
        )
    }

    // MARK: - Portrait Layout

    static func portraitLayout(screenSize: CGSize) -> GBCControllerLayoutDefinition {
        // iPhone 17 reference
        let baseWidth: CGFloat = 393
        let baseHeight: CGFloat = 852
        
        let widthRatio = screenSize.width / baseWidth
        let heightRatio = screenSize.height / baseHeight
        
        // Scaled constants
        let buttonSize = CGSize(width: 55 * widthRatio, height: 55 * widthRatio)
        let dpadRadius: CGFloat = 60 * widthRatio
        let smallButtonSize = CGSize(width: 45 * widthRatio, height: 20 * heightRatio)
        
        // Controls area (same relative position)
        let controlsY = screenSize.height * 0.72 * heightRatio
        
        // D-Pad (bottom-left)
        let dpadCenter = CGPoint(
            x: 95 * widthRatio,
            y: controlsY + (110 * heightRatio)
        )
        
        // Action buttons (bottom-right)
        let actionButtonsCenter = CGPoint(
            x: screenSize.width - (95 * widthRatio),
            y: controlsY + (110 * heightRatio)
        )
        
        let diagonalOffset: CGFloat = 28 * widthRatio
        
        let actionButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x - diagonalOffset,
                    y: actionButtonsCenter.y - diagonalOffset
                ),
                size: buttonSize,
                button: .b
            ),
            ButtonLayout(
                position: CGPoint(
                    x: actionButtonsCenter.x + diagonalOffset,
                    y: actionButtonsCenter.y + diagonalOffset
                ),
                size: buttonSize,
                button: .a
            )
        ]
        
        // Start/Select (centered above bottom edge)
        let centerButtonsY = screenSize.height - (70 * heightRatio)
        
        let centerButtons: [ButtonLayout] = [
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 - (40 * widthRatio),
                    y: centerButtonsY + (100 * heightRatio)
                ),
                size: smallButtonSize,
                button: .select
            ),
            ButtonLayout(
                position: CGPoint(
                    x: screenSize.width / 2 + (40 * widthRatio),
                    y: centerButtonsY + (100 * heightRatio)
                ),
                size: smallButtonSize,
                button: .start
            )
        ]
        
        return GBCControllerLayoutDefinition(
            mode: .portrait,
            dpad: DPadLayout(center: dpadCenter, radius: dpadRadius),
            actionButtons: actionButtons,
            centerButtons: centerButtons
        )
    }
}

struct GBCControllerLayoutDefinition {
    let mode: GBCControllerLayout.LayoutMode
    let dpad: GBCControllerLayout.DPadLayout
    let actionButtons: [GBCControllerLayout.ButtonLayout]
    let centerButtons: [GBCControllerLayout.ButtonLayout]
}
