//
//  GuideScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct GuideScreenView: View {
    @State private var currentCategory: GuidePageEnum = .step
    
    var body: some View {
        ZStack {
            AppBackGround()
            
            VStack(spacing: 12) {
                AppTopBar(title: "Guide")
                
                VStack(spacing: 16) {
                    GuideCategory(currentCategory: $currentCategory)
                    
                    currentCategory.body
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    GuideScreenView()
}
