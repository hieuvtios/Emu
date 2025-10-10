//
//  GBCThemeManager.swift
//  GameEmulator
//
//  Manages GBC controller theme selection and persistence
//  DEBUG BUILD ONLY
//

#if DEBUG

import Foundation
import SwiftUI
import Combine

class GBCThemeManager: ObservableObject {
    private static let themeStorageKey = "GBCControllerTheme"

    @Published var currentTheme: GBCControllerTheme {
        didSet {
            saveTheme()
        }
    }

    let availableThemes: [GBCControllerTheme] = GBCControllerTheme.allThemes

    // MARK: - Initialization

    init() {
        self.currentTheme = Self.loadTheme()
    }

    // MARK: - Public Methods

    func selectTheme(_ theme: GBCControllerTheme) {
        currentTheme = theme
    }

    func resetToDefault() {
        currentTheme = .defaultTheme
    }

    // MARK: - Persistence

    private static func loadTheme() -> GBCControllerTheme {
        guard let data = UserDefaults.standard.data(forKey: themeStorageKey),
              let theme = try? JSONDecoder().decode(GBCControllerTheme.self, from: data) else {
            return .defaultTheme
        }
        return theme
    }

    private func saveTheme() {
        guard let data = try? JSONEncoder().encode(currentTheme) else { return }
        UserDefaults.standard.set(data, forKey: Self.themeStorageKey)
    }
}

#endif
