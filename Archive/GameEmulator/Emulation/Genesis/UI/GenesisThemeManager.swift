//
//  GenesisThemeManager.swift
//  GameEmulator
//
//  Manages Genesis controller theme selection and persistence
//  DEBUG BUILD ONLY
//

#if DEBUG

import Foundation
import SwiftUI
import Combine

extension Notification.Name {
    static let GenesisThemeDidChange = Notification.Name("GenesisThemeDidChangeNotification")
}

class GenesisThemeManager: ObservableObject {
    private static let themeStorageKey = "GenesisControllerTheme"

    @Published var currentTheme: GenesisControllerTheme {
        didSet {
            saveTheme()
            NotificationCenter.default.post(name: .GenesisThemeDidChange, object: currentTheme)
        }
    }

    let availableThemes: [GenesisControllerTheme] = GenesisControllerTheme.allThemes

    // MARK: - Initialization

    init() {
        self.currentTheme = Self.loadTheme()
    }

    // MARK: - Public Methods

    func selectTheme(_ theme: GenesisControllerTheme) {
        currentTheme = theme
    }

    func resetToDefault() {
        currentTheme = .defaultTheme
    }

    // MARK: - Persistence

    private static func loadTheme() -> GenesisControllerTheme {
        guard let data = UserDefaults.standard.data(forKey: themeStorageKey),
              let theme = try? JSONDecoder().decode(GenesisControllerTheme.self, from: data) else {
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
