
#if DEBUG

import Foundation
import SwiftUI
import Combine

extension Notification.Name {
    static let DSThemeDidChange = Notification.Name("DSThemeDidChangeNotification")
}

class DSThemeManager: ObservableObject {
    private static let themeStorageKey = "DSControllerTheme"

    @Published var currentTheme: DSControllerTheme {
        didSet {
            saveTheme()
            NotificationCenter.default.post(name: .DSThemeDidChange, object: currentTheme)
        }
    }

    let availableThemes: [DSControllerTheme] = DSControllerTheme.allThemes

    // MARK: - Initialization

    init() {
        self.currentTheme = Self.loadTheme()
    }

    // MARK: - Public Methods

    func selectTheme(_ theme: DSControllerTheme) {
        currentTheme = theme
    }

    func resetToDefault() {
        currentTheme = .defaultTheme
    }

    // MARK: - Persistence

    private static func loadTheme() -> DSControllerTheme {
        guard let data = UserDefaults.standard.data(forKey: themeStorageKey),
              let theme = try? JSONDecoder().decode(DSControllerTheme.self, from: data) else {
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
