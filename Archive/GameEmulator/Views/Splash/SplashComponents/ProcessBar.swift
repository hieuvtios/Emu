//
//  ProcessBar.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI

struct ProcessBar: View {
    @Binding var progress: Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color(.colorFFE2B8)).frame(height: 16)
                .cornerRadius(16)
            
            GeometryReader { geo in
                Rectangle()
                    .fill(Color(.colorFEC200))
                    .frame(width: geo.size.width * progress, height: 16)
                    .cornerRadius(16)
                    .animation(.linear(duration: 3), value: progress)
            }
        }
        .frame(height: 16)
    }
}
