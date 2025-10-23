//
//  YourGameScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct YourGameScreenView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject var tabViewModel: TabViewModel

    var body: some View {
        ZStack {
            AppBackGround()

            VStack(spacing: 16) {
                AppTopBar(title: "Your Game")

                HomeCategory()
                    .padding(.leading, 20)

                ScrollView(.vertical, showsIndicators: false) {
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
                    let height: CGFloat = 237

                    if homeViewModel.filteredGames.isEmpty {
                        // Empty state
                        VStack(spacing: 16) {
                            Image(systemName: "gamecontroller")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)

                            Text("No games yet")
                                .font(.title3)
                                .foregroundColor(.white)

                            Text("Import games to see them here")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(homeViewModel.filteredGames) { game in
                                YourGameItem(
                                    game: game,
                                    onTap: {
                                        tabViewModel.launchGame(game)
                                    },
                                    onDelete: {
                                        homeViewModel.deleteGame(game)
                                    },
                                    onToggleFavorite: {
                                        homeViewModel.toggleFavorite(game)
                                    }
                                )
                                .frame(height: height)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    YourGameScreenView()
        .environmentObject(TabViewModel())
}
