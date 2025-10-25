//
//  YourGameItem.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct YourGameItem: View {
    let game: GameEntity
    let onTap: () -> Void
    let onDelete: () -> Void
    let onToggleFavorite: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Artwork placeholder
            ZStack {
                Rectangle()
                    .fill(LinearGradient(
                        colors: [Color(red: 0.1, green: 0.3, blue: 0.7), Color(red: 0.05, green: 0.15, blue: 0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))

                VStack {
                    // Game type badge
                    Text(gameTypeDisplayName)
                        .font(Font.custom("Chakra Petch", size: 12).weight(.bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(4)

                    Spacer()

                    // Favorite indicator
                    if game.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 24))
                    }
                }
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(height: 150)

            // Game info section
            HStack(alignment: .bottom, spacing: 4) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.name)
                        .font(Font.custom("Chakra Petch", size: 14).weight(.bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(gameSubtitle)
                        .font(Font.custom("Inter", size: 10))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // More menu button
                Menu {
                    Button(action: onToggleFavorite) {
                        Label(game.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                              systemImage: game.isFavorite ? "star.slash" : "star")
                    }

                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image("home_ic_more")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            .background(Color(red: 0.07, green: 0.24, blue: 0.63))
        }
        .cornerRadius(8)
        .onTapGesture {
            onTap()
        }
    }

    // MARK: - Computed Properties

    private var gameTypeDisplayName: String {
        if game.gameType.contains("snes") {
            return "SNES"
        } else if game.gameType.contains("nes") {
            return "NES"
        } else if game.gameType.contains("gbc") {
            return "GBC"
        } else if game.gameType.contains("gba") {
            return "GBA"
        } else if game.gameType.contains("n64") {
            return "N64"
        } else {
            return "ROM"
        }
    }

    private var gameSubtitle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let dateString = dateFormatter.string(from: game.dateAdded)

        if let lastPlayed = game.lastPlayed {
            let playedString = dateFormatter.string(from: lastPlayed)
            return "\(gameTypeDisplayName) • Last played: \(playedString)"
        } else {
            return "\(gameTypeDisplayName) • Added: \(dateString)"
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let game = GameEntity(context: context)
    game.id = UUID()
    game.name = "Pokemon - Ruby Version"
    game.fileName = "pokemon.gba"
    game.fileExtension = "gba"
    game.gameType = "com.rileytestut.delta.game.gba"
    game.dateAdded = Date()
    game.isFavorite = true

    return YourGameItem(
        game: game,
        onTap: {},
        onDelete: {},
        onToggleFavorite: {}
    )
    .frame(height: 237)
    .padding()
}
