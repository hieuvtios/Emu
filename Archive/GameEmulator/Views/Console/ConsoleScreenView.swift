//
//  ConsoleScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

struct ConsoleScreenView: View {
    
    @StateObject var consoleViewModel = ConsoleViewModel()
    
    var body: some View {
        VStack {
            HomeTopBar(title: "Console")
            
            ConsoleCategory(currentCategory: $consoleViewModel.consoleCurrentCate)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            
            switch consoleViewModel.consoleCurrentCate {
            case .allConsole:
                AllConsoleScreenView(consoleViewModel: consoleViewModel)
            case .myConsole:
                MyConsoleScreenView()
            }
        }
    }
}

#Preview {
    TabScreenView()
}
