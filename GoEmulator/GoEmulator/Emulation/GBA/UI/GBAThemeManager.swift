//
//  GBAThemeManager.swift
//  GameEmulator
//
//  Manages GBA controller theme selection and persistence
//  DEBUG BUILD ONLY
//

#if DEBUG

import Foundation
import SwiftUI
import Combine

extension Notification.Name {
    static let gbaThemeDidChange = Notification.Name("GBAThemeDidChangeNotification")
}

class GBAThemeManager: ObservableObject {
    private static let themeStorageKey = "GBAControllerTheme"

    @Published var currentTheme: GBAControllerTheme {
        didSet {
            saveTheme()
            NotificationCenter.default.post(name: .gbaThemeDidChange, object: currentTheme)
        }
    }

    let availableThemes: [GBAControllerTheme] = GBAControllerTheme.allThemes

    // MARK: - Initialization

    init() {
        self.currentTheme = Self.loadTheme()
    }

    // MARK: - Public Methods

    func selectTheme(_ theme: GBAControllerTheme) {
        currentTheme = theme
    }

    func resetToDefault() {
        currentTheme = .defaultTheme
    }

    // MARK: - Persistence

    private static func loadTheme() -> GBAControllerTheme {
        guard let data = UserDefaults.standard.data(forKey: themeStorageKey),
              let theme = try? JSONDecoder().decode(GBAControllerTheme.self, from: data) else {
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
