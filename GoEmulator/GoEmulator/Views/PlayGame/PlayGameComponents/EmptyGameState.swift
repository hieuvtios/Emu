//
//  EmptyGameState.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct EmptyGameState: View {
    var body: some View {
        VStack {
            Image("image 2009")
            
            // Title/24px/Bold
            Text("No saved states")
                .font(Font.custom("SVN-Determination Sans", size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Body/16px/Light
            Text("Save now to avoid game interruptions")
                .font(
                    Font.custom("Chakra Petch", size: 16)
                        .weight(.light)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                .frame(maxWidth: .infinity, alignment: .top)
        }
    }
}

#Preview {
    EmptyGameState()
}
