//
//  AllConsoleScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct AllConsoleScreenView: View {
    
    @ObservedObject var consoleViewModel: ConsoleViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(consoleViewModel.allConsoleThemes, id: \.self) { item in
                    Image(item)
                        .resizable()
                        .scaledToFit()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .inset(by: 1)
                                .stroke(Color(red: 0.94, green: 0.69, blue: 0.98), lineWidth: consoleViewModel.currentThemeSelected == item ? 4 : 0)
                        )
                        .cornerRadius(10)
                        .overlay(alignment: .topLeading) {
                            if consoleViewModel.currentThemeSelected == item {
                                Image("lets-icons_check-fill")
                                    .padding(2)
                            }
                        }
                        .onTapGesture {
                            consoleViewModel.currentThemeSelected = item
                        }
                }
            }
            
            Spacer().frame(height: 100)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    TabScreenView()
}
