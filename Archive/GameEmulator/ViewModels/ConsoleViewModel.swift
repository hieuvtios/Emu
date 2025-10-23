//
//  ConsoleViewModel.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

class ConsoleViewModel: ObservableObject {
    @Published var consoleCurrentCate: ConsoleEnum = .allConsole
    
    @Published var currentThemeSelected: String = "console_theme_1"
    @Published var allConsoleThemes: [String] = [
        "console_theme_1", "console_theme_2", "console_theme_3", "console_theme_4", "console_theme_5", "console_theme_6", "console_theme_7", "console_theme_8", "console_theme_9"
    ]
}
