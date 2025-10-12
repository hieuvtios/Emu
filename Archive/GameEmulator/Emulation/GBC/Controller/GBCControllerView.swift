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
