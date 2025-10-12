//
//  HomeViewModel.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 3/10/25.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var allGames: [GameEntity] = []
    @Published var favoriteGames: [GameEntity] = []
    @Published var recentlyPlayedGames: [GameEntity] = []

    private let gameManager = GameManager.shared
    private var cancellables = Set<AnyCancellable>()

    /// Computed property for filtered games based on search
    var filteredGames: [GameEntity] {
        if searchText.isEmpty {
            return allGames
        } else {
            return allGames.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    init() {
        loadGames()
        setupNotificationObserver()
    }

    /// Load all games from CoreData
    func loadGames() {
        allGames = gameManager.fetchAllGames()
        favoriteGames = gameManager.fetchFavoriteGames()
        recentlyPlayedGames = gameManager.fetchRecentlyPlayedGames()

        print("📚 Loaded \(allGames.count) games from library")
    }

    /// Refresh games list
    func refreshGames() {
        loadGames()
    }

    /// Toggle favorite status
    func toggleFavorite(_ game: GameEntity) {
        gameManager.toggleFavorite(game)
        refreshGames()
    }

    /// Delete a game
    func deleteGame(_ game: GameEntity) {
        gameManager.deleteGame(game)
        refreshGames()
    }

    /// Setup notification observer for game library updates
    private func setupNotificationObserver() {
        NotificationCenter.default.publisher(for: .gameLibraryUpdated)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshGames()
            }
            .store(in: &cancellables)
    }
}

