//
//  AppBackGround.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 5/10/25.
//

import SwiftUI

struct AppBackGround: View {
    var body: some View {
        Image("app_bg")
            .resizable()
            .ignoresSafeArea()
    }
}

#Preview {
    AppBackGround()
}
