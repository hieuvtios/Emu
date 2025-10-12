//
//  CheatCodeInfo.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct CheatCodeInfo: View {
    var body: some View {
        ZStack {
            AppBackGround()
            
            VStack {
                AppTopBar(title: "Cheat code")
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        cheatCodeGuide(number: "1", title: "Start your game and click on the “Game Menu” to find the section for “Cheat Codes”.", image: "Export Here")
                        
                        cheatCodeGuide(number: "2", title: "Open your browser (we recommend you can use web search in Gamehub) or click on the available links here to find the right cheat code, then copy it.", image: "Play Game 3", showLink: true)
                        
                        cheatCodeGuide(number: "3", title: "Go back to the app, paste the code into 'Add New Code', then save it.", image: "Play Game 2")
                        
                        cheatCodeGuide(number: "4", title: "Go back to the app, paste the code into 'Add New Code', then save it..", image: "Play Game 1")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                
                Text("*Note: The cheat code is only active while playing the game. If you exit and re-enter the game, you need to reapply the cheat code following the steps in section 4 to use it.")
                    .font(
                        Font.custom("Chakra Petch", size: 14)
                            .weight(.medium)
                            .italic()
                    )
                    .foregroundColor(Color(red: 1, green: 0.7, blue: 0.25))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder
    func cheatCodeGuide(number: String, title: String, image: String, showLink: Bool = false) -> some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Text(number)
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
                    .font(Font.custom("Inter", size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(image)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 11)
            
            if showLink {
                Text("https://www.pokemoncoders.com/\nhttps://etherealgames.com/ \nhttps://www.gamegenie.com/ ")
                    .font(Font.custom("Inter", size: 14))
                    .underline()
                    .foregroundColor(.white)
                    .frame(width: 328, alignment: .topLeading)
            }
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    CheatCodeInfo()
}
