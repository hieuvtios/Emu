//
//  GuideCategory.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct GuideCategory: View {
    
    @Binding var currentCategory: GuidePageEnum
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
        
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(GuidePageEnum.allCases) { cate in
                Button {
                    currentCategory = cate
                } label: {
                    Text(cate.rawValue)
                        .font(
                            Font.custom("Chakra Petch", size: 16)
                                .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(currentCategory == cate ? Color(red: 0.54, green: 0.09, blue: 0.61) : Color(red: 0.77, green: 0.84, blue: 0.99))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 2)
                        .frame(maxWidth: .infinity, minHeight: 32, maxHeight: 32, alignment: .center)
                        .background(currentCategory == cate ? Color(red: 0.94, green: 0.69, blue: 0.98) : .clear)
                        .cornerRadius(42)
                }
            }
        }
    }
}
