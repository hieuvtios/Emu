//
//  NESThemeManager.swift
//  GameEmulator
//
//  Created by Hieu Vu on 10/12/25.
//


//
//  NESThemeManager.swift
//  GameEmulator
//
//  Manages NES controller theme selection and persistence
//  DEBUG BUILD ONLY
//

#if DEBUG

import Foundation
import SwiftUI
import Combine

extension Notification.Name {
    static let NESThemeDidChange = Notification.Name("NESThemeDidChangeNotification")
}

class NESThemeManager: ObservableObject {
    private static let themeStorageKey = "NESControllerTheme"

    @Published var currentTheme: NESControllerTheme {
        didSet {
            saveTheme()
            NotificationCenter.default.post(name: .NESThemeDidChange, object: currentTheme)
        }
    }

    let availableThemes: [NESControllerTheme] = NESControllerTheme.allThemes

    // MARK: - Initialization

    init() {
        self.currentTheme = Self.loadTheme()
    }

    // MARK: - Public Methods

    func selectTheme(_ theme: NESControllerTheme) {
        currentTheme = theme
    }

    func resetToDefault() {
        currentTheme = .defaultTheme
    }

    // MARK: - Persistence

    private static func loadTheme() -> NESControllerTheme {
        guard let data = UserDefaults.standard.data(forKey: themeStorageKey),
              let theme = try? JSONDecoder().decode(NESControllerTheme.self, from: data) else {
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
