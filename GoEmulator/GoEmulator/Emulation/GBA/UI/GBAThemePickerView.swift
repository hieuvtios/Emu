//
//  GBAThemePickerView.swift
//  GameEmulator
//
//  Theme selection interface for GBA controller
//  DEBUG BUILD ONLY
//

#if DEBUG

import SwiftUI

struct GBAThemePickerView: View {
    @ObservedObject var themeManager: GBAThemeManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(themeManager.availableThemes) { theme in
                    Button(action: {
                        themeManager.selectTheme(theme)
                    }) {
                        HStack {
                            Text(theme.name)
                                .font(.headline)

                            Spacer()

                            if theme.id == themeManager.currentTheme.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("GBA Controller Themes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Reset") {
                        themeManager.resetToDefault()
                    }
                }
            }
        }
    }
}

#endif
