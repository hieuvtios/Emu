//
//  GuideStepScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct GuideStepScreenView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                Text("Hey, gamers! If your games are compressed in ZIP or RAR files, go ahead and unzip them first. To keep things organized, set up separate folders for each system using the following names: nes, snes,3ds, n64 gb, gbc, gba, sega genessis. This way, everything stays neat, and you can easily find your games whenever you’re ready to dive in!")
                    .font(Font.custom("SVN-Determination Sans", size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                stepView(step: "1", title: "Start download game", img: "guide_step_1", descrip: "You can browse or search for the games you love, or explore recommended websites in the SITE section for more options.")
                
                stepView(step: "2", title: "Select Your Favourite Game", img: "guide_step_2", descrip: "Choose your favorite games based on the console, and explore a massive collection of titles from various genres that bring back childhood memories!")
                
                stepView(step: "3", title: "Press “Save Game”", img: "guide_step_3", descrip: "Press \"Save Game\" to download your favorite games to your device. You can download multiple games at once and build one of the most enjoyable gaming experiences ever!. You can save the games in any folder on your phone, but it’s best to keep them in one folder for easy management.\nLoad your favourite games")
                
                stepView(step: "4", title: "Load your favourite game", img: "guide_step_4", descrip: "Go back to the app and press:  Import (Manual Select) Tap Import to manually browse and select your game files from your device storage.\n Quick Scan (Auto Detect) Tap Quick Scan to let the app automatically search your device and import all supported game files in seconds.")
                
            }
        }
    }
    
    @ViewBuilder
    func stepView(step: String, title: String, img: String, descrip: String) -> some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Text(step)
                    .font(
                        Font.custom("Chakra Petch", size: 20)
                            .weight(.bold)
                    )
                    .foregroundColor(Color(red: 0.54, green: 0.09, blue: 0.61))
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color(red: 0.94, green: 0.69, blue: 0.98))
                    )
                
                Text(title)
                    .font(
                        Font.custom("Chakra Petch", size: 20)
                            .weight(.semibold)
                    )
                    .foregroundColor(Color(red: 0.94, green: 0.69, blue: 0.98))
                
                Spacer()
            }
            
            HStack(alignment: .center, spacing: 12) {
                Image(img)
                    .resizable()
                    .scaledToFit()
                
                Text(descrip)
                    .font(Font.custom("SVN-Determination Sans", size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    GuideStepScreenView()
}
