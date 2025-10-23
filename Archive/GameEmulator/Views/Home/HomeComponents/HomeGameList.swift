//
//  HomeGameList.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 4/10/25.
//

import SwiftUI

struct HomeGameList: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var tabViewModel: TabViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                HomeRecentPlay()

                HomeFavorite()

                HomeTopTitle(title: "Your  Game")

                HomeCategory()

                // Display games from CoreData
                let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
                let height: CGFloat = 237

                if homeViewModel.filteredGames.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "gamecontroller")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)

                        Text(homeViewModel.searchText.isEmpty ? "No games yet" : "No games found")
                            .font(.title3)
                            .foregroundColor(.white)

                        if homeViewModel.searchText.isEmpty {
                            Text("Tap the + button to add your first game!")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(homeViewModel.filteredGames) { game in
                            YourGameItem(
                                game: game,
                                onTap: {
                                    // Launch the game
                                    tabViewModel.launchGame(game)
                                },
                                onDelete: {
                                    // Delete the game
                                    homeViewModel.deleteGame(game)
                                },
                                onToggleFavorite: {
                                    // Toggle favorite
                                    homeViewModel.toggleFavorite(game)
                                }
                            )
                            .frame(height: height)
                        }
                    }
                }
            }

            Spacer().frame(height: 100)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
}

#Preview {
    HomeGameList()
        .environmentObject(HomeViewModel())
        .environmentObject(TabViewModel())
}
