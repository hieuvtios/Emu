//
//  AppButton.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI

struct AppButton: View {
    
    let title: String
    var onTapAction: () -> ()
    
    var body: some View {
        Button {
            onTapAction()
        } label: {
            Image("ob_button")
                .resizable()
                .scaledToFit()
                .overlay {
                    Text(title)
                        .font(Font.custom("SVN-Determination Sans", size: 20))
                        .foregroundColor(Color(.color8B189C))
                }
        }
    }
}
