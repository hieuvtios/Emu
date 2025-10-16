
#if DEBUG

import Foundation
import SwiftUI
import Combine

extension Notification.Name {
    static let SNESThemeDidChange = Notification.Name("SNESThemeDidChangeNotification")
}

class SNESThemeManager: ObservableObject {
    private static let themeStorageKey = "NESControllerTheme"

    @Published var currentTheme: SNESControllerTheme {
        didSet {
            saveTheme()
            NotificationCenter.default.post(name: .SNESThemeDidChange, object: currentTheme)
        }
    }

    let availableThemes: [SNESControllerTheme] = SNESControllerTheme.allThemes

    // MARK: - Initialization

    init() {
        self.currentTheme = Self.loadTheme()
    }

    // MARK: - Public Methods

    func selectTheme(_ theme: SNESControllerTheme) {
        currentTheme = theme
    }

    func resetToDefault() {
        currentTheme = .defaultTheme
    }

    // MARK: - Persistence

    private static func loadTheme() -> SNESControllerTheme {
        guard let data = UserDefaults.standard.data(forKey: themeStorageKey),
              let theme = try? JSONDecoder().decode(SNESControllerTheme.self, from: data) else {
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
