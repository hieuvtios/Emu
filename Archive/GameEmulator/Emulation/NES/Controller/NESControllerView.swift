import SwiftUI

struct NESControllerView: View {
    let controller: NESGameController

    @State private var buttonStates: [NESButtonType: Bool] = [:]
    @State private var dpadButtons: Set<NESButtonType> = []
    @State private var currentLayout: NESControllerLayoutDefinition?

    #if DEBUG
    @StateObject private var themeManager = NESThemeManager()
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
                        NESDPadView(
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
                            NESButtonView(
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
                            NESCenterButtonView(
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
                NESThemePickerView(themeManager: themeManager)
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
            currentLayout = NESControllerLayout.landscapeLayout(screenSize: size)
        } else {
            currentLayout = NESControllerLayout.portraitLayout(screenSize: size)
        }
    }

    // MARK: - Theme Helper

    private func getCurrentTheme() -> NESControllerTheme {
        #if DEBUG
        return themeManager.currentTheme
        #else
        return .defaultTheme
        #endif
    }
}
// Preview this view
//struct NESControllerView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            // Portrait Preview
//            NESControllerView(controller: NESDirectController(name: "Preview Controller"))
//                .previewDisplayName("Portrait")
//                .previewInterfaceOrientation(.portrait)
//            
//            // Landscape Preview
//            NESControllerView(controller: NESDirectController(name: "Preview Controller"))
//                .previewDisplayName("Landscape")
//                .previewInterfaceOrientation(.landscapeLeft)
//        }
//    }
//}
