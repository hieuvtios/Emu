//
//  AppButton2.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct DismissButton: View {
    let title: String
    var onTapAction: () -> ()
    
    var body: some View {
        Button {
            onTapAction()
        } label: {
            Image("ob_button_2")
                .resizable()
                .scaledToFill()
                .overlay {
                    Text(title)
                        .font(Font.custom("SVN-Determination Sans", size: 20))
                        .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                }
        }
    }
}
