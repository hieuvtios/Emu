//
//  AppTopBar.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct AppTopBar: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    
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
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
}

#Preview {
    AppTopBar(title: "Hello")
}
