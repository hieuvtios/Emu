//
//  AutoSaveButton.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct AutoSaveButton: View {
    let title: String
    var onTapAction: () -> ()
    
    var body: some View {
        Button {
            onTapAction()
        } label: {
            Image("ob_button_3")
                .resizable()
                .scaledToFill()
                .overlay {
                    Text(title)
                        .font(Font.custom("SVN-Determination Sans", size: 20))
                        .foregroundColor(Color(red: 0.54, green: 0.09, blue: 0.61))
                }
        }
    }
}
