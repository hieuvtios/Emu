//
//  LoadSateScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct LoadSateScreenView: View {
    var body: some View {
        ZStack {
            AppBackGround()
            
            VStack {
                AppTopBar(title: "Load state")
                
                ScrollView(.vertical, showsIndicators: false) {
//                    VStack(spacing: 12) {
//                        ForEach(0..<5) { _ in
//                            LoadStateItem()
//                        }
//                    }
                }
                .padding(.horizontal, 20)
            }
            .overlay {
                EmptyGameState()
            }
        }
    }
}

#Preview {
    LoadSateScreenView()
}
