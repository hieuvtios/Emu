//
//  SettingTopTitle.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 11/10/25.
//

import SwiftUI

struct SettingTopTitle: View {
    var body: some View {
        Text("Settings")
            .font(Font.custom("SVN-Determination Sans", size: 32))
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
    }
}

#Preview {
    SettingTopTitle()
}
