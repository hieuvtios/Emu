//
//  GBCThemePickerView.swift
//  GameEmulator
//
//  Theme selection UI for GBC controller
//  DEBUG BUILD ONLY
//

#if DEBUG

import SwiftUI

struct GBCThemePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var themeManager: GBCThemeManager

    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 20)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Choose your controller theme")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top)

                    // Theme Grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(themeManager.availableThemes) { theme in
                            ThemeCard(
                                theme: theme,
                                isSelected: theme.id == themeManager.currentTheme.id,
                                onSelect: {
                                    themeManager.selectTheme(theme)
                                    dismiss()
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Controller Themes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        themeManager.resetToDefault()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Theme Card Component

private struct ThemeCard: View {
    let theme: GBCControllerTheme
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // Preview
            ZStack {
                // Background preview
                Image(theme.backgroundPortraitImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(16)

                // Overlay with D-Pad to show theme
                VStack {
                    Spacer()
                    HStack {
                        Image(theme.dpadImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.leading, 8)
                            .padding(.bottom, 8)
                        Spacer()
                    }
                }
            }
            .frame(height: 120)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
            )

            // Theme Name
            Text(theme.name)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .blue : .primary)

            // Selected Badge
            if isSelected {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                    Text("Selected")
                        .font(.caption)
                }
                .foregroundColor(.blue)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .onTapGesture {
            onSelect()
        }
    }
}

// MARK: - Preview

#Preview {
    GBCThemePickerView(themeManager: GBCThemeManager())
}

#endif
