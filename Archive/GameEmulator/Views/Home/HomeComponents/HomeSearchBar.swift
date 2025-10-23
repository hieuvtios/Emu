//
//  HomeSearchBar.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 3/10/25.
//

import SwiftUI

struct HomeSearchBar: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(.homeIcSearch)
            
            TextField("", text: $searchText)
                .placeholder(when: searchText.isEmpty) {
                    Text("Search your game")
                        .font(Font.custom("Chakra Petch", size: 16))
                        .foregroundColor(Color(.grey200))
                }
                .font(Font.custom("Chakra Petch", size: 16))
                .foregroundColor(Color(.grey200))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.color001441))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.75)
                .stroke(.white.opacity(0.25), lineWidth: 1.5)
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }
}
