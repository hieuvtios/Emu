//
//  SplashScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var progress = 0.0
    @State private var showOnboarding = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("splash_bg").resizable().ignoresSafeArea()
            
            ProcessBar(progress: $progress)
                .padding(.horizontal, 20)
                .padding(.bottom, 65)
        }
        .onAppear {
            progress = 1.0
        }
    }
}

#Preview {
    SplashScreenView()
}
