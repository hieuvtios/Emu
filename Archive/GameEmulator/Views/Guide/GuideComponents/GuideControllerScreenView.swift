//
//  GuideControllerScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 8/10/25.
//

import SwiftUI

struct GuideControllerScreenView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 9) {
                Text("Go Emulator supports a wide range of external controllers, including but not limited to PS Dualshock, Joy-Con, Xbox controllers, Bluetooth keyboards, and more. Any wired or wireless device certified by iOS MFi can be used as a controller. Ready to dive into retro gaming? Follow these simple setup steps!")
                  .font(Font.custom("SVN-Determination Sans", size: 14))
                  .foregroundColor(.white)
                
                item(title: "Basic Connection Guide", text: " 1. Bluetooth Pairing: Go to iOS Settings > Bluetooth and connect your external device.  \n\n2. Controller Management: Access the controller management page via the top-left button in the game list (top-right for RTL languages), or adjust settings mid-game via the quick menu. \n\n 3. Multiplayer Setup: Enjoy split controls! For example, in Snow Bros, use on-screen buttons for Player 1 and an external controller for Player 2.")
                
                item(title: "# Joy-Con Controller Connection", text: "\nRequirements\n\n- OS Version: iOS 16 / iPadOS 16 or later \n- Supported Devices: iPhone 8 or newer, iPadOS 16–compatible iPads \n- Controller Types: Switch Joy-Con (single/pair), Switch Pro\n\nSingle Joy-Con Pairing\n\n1. Start Pairing: Press and hold the Pairing Button (small circle) on the Joy-Con until the LED indicators flash sequentially\n\n2. Bluetooth Connection: Select Joy-Con (L) or Joy-Con (R) in iOS Bluetooth settings.\n\nSplit Joy-Con Mode\n\nWant to use left/right Joy-Con as separate controllers? In controller management page:\n\n1. Hold Left Joy-Con Capture Button + Right Joy-Con Home Button for 3–5 seconds. \n2. Once split, enjoy two-player local battles!")
                
                item(title: "# Xbox Controller Connection", text: "\nSupported Models\n\n- Xbox Wireless Controller (Bluetooth, Model 1708) \n- Xbox Series S/X Wireless Controller \n- Xbox Elite Wireless Controller Series 2 \n- Xbox Adaptive Controller\n\nPairing Steps\n\n1. Power On: Press the Xbox Button to turn on the controller.  \n\n2. Pairing Mode: Hold the Connect Button until the LED blinks rapidly.  \n\n3. Bluetooth Connection: Select the controller name in iOS Bluetooth settings.")
                
                item(title: "# Troubleshooting", text: "\nIf your controller fails to connect or function properly:\n\n1. Update Firmware: Ensure both your iOS device and controller are updated.\n\n2. Re-pair Device: “Forget” the device in Bluetooth settings and reconnect.\n\n3. Reduce Interference: Disconnect other Bluetooth devices for a stable connection.\n\n4. Charge Properly: Use the original charger or manufacturer-recommended solution.\n\nNote: Some features (e.g., audio jack, RGB lighting) may vary by app compatibility. Stay tuned for updates!\n\nGrab your controller and start your retro gaming adventure!")
            }
        }
    }
    
    @ViewBuilder
    func item(title: String, text: String) -> some View {
        VStack(spacing: 3) {
            // 14px/Regular
            Text(title)
                .font(
                    Font.system(size: 14).bold()
                )
                .underline()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Body/14px/Regular
            Text(text)
                .font(Font.custom("Chakra Petch", size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    GuideControllerScreenView()
}
