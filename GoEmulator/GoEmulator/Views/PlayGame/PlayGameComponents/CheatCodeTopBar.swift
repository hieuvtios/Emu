//
//  CheatCodeTopBar.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct CheatCodeTopBar: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    let onTapInfoAction: () -> ()
    
    var body: some View {
        ZStack {
            Text(title)
                .font(Font.custom("SVN-Determination Sans", size: 22))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("home_left_arrow")
                }
                
                Spacer()
                
                Button {
                    onTapInfoAction()
                } label: {
                    Image("Info Circle")
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
}
