//
//  N64ThemeManager.swift
//  GameEmulator
//
//  Manages N64 controller theme selection and persistence
//  DEBUG BUILD ONLY
//

import Foundation
import SwiftUI
import Combine

extension Notification.Name {
    static let n64ThemeDidChange = Notification.Name("N64ThemeDidChangeNotification")
}

class N64ThemeManager: ObservableObject {
    private static let themeStorageKey = "N64ControllerTheme"

    @Published var currentTheme: N64ControllerTheme {
        didSet {
            saveTheme()
            NotificationCenter.default.post(name: .n64ThemeDidChange, object: currentTheme)
        }
    }

    let availableThemes: [N64ControllerTheme] = N64ControllerTheme.allThemes

    // MARK: - Initialization

    init() {
        self.currentTheme = Self.loadTheme()
    }

    // MARK: - Public Methods

    func selectTheme(_ theme: N64ControllerTheme) {
        currentTheme = theme
    }

    func resetToDefault() {
        currentTheme = .defaultTheme
    }

    // MARK: - Persistence

    private static func loadTheme() -> N64ControllerTheme {
        guard let data = UserDefaults.standard.data(forKey: themeStorageKey),
              let theme = try? JSONDecoder().decode(N64ControllerTheme.self, from: data) else {
            return .defaultTheme
        }
        return theme
    }

    private func saveTheme() {
        guard let data = try? JSONEncoder().encode(currentTheme) else { return }
        UserDefaults.standard.set(data, forKey: Self.themeStorageKey)
    }
}
