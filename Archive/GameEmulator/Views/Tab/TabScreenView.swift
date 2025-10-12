//
//  TabScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 4/10/25.
//

import SwiftUI

enum AppScreen: Hashable, Identifiable, CaseIterable {
    
    case home
    case guide
    case addGame
    case console
    case setting
    
    var id: AppScreen { self }
}

extension AppScreen {

    var label: String {
        switch self {
        case .home:
            "Home"
        case .guide:
            "Guide"
        case .console:
            "Console"
        case .setting:
            "Setting"
        case .addGame:
            ""
        }
    }
    
    var icon_select: String {
        switch self {
        case .home:
            "tab_ic_home_select"
        case .guide:
            "tab_ic_home_select"
        case .console:
            "tab_ic_home_select"
        case .setting:
            "tab_ic_home_select"
        case .addGame:
            ""
        }
    }
    
    var icon_unselect: String {
        switch self {
        case .home:
            "tab_ic_home_select"
        case .guide:
            "tab_ic_home_select"
        case .console:
            "tab_ic_home_select"
        case .setting:
            "tab_ic_home_select"
        case .addGame:
            ""
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            HomeScreenView()
        case .guide:
            EmptyView()
        case .console:
            EmptyView()
        case .setting:
            EmptyView()
        case .addGame:
            EmptyView()
        }
    }
}

struct TabScreenView: View {

    @StateObject var tabViewModel = TabViewModel()

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $tabViewModel.tabSelection) {
                ForEach(AppScreen.allCases) { screen in
                    screen.destination
                        .tag(screen as AppScreen?)
                        .environmentObject(tabViewModel)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(content: {
                if tabViewModel.isExpanded {
                    Color(.color000000).opacity(0.8)
                }
            })
            .overlay(alignment: .bottom) {
                BottomTabView(tabViewModel: tabViewModel, addGameAction: { action in
                    tabViewModel.showDocumentPicker = true
                })
                .padding(.bottom, 30)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $tabViewModel.showDocumentPicker, onDismiss: {}, content: {
            DocumentPicker(documentTypes: []) { importedURLs in
                // Handle imported game files
                tabViewModel.handleImportedGames(importedURLs)
            }
        })
        .fullScreenCover(isPresented: $tabViewModel.showGameView) {
            if let game = tabViewModel.selectedGame {
                ContentView(game: game)
            }
        }
        .alert("Success", isPresented: .constant(tabViewModel.importSuccessMessage != nil), presenting: tabViewModel.importSuccessMessage) { _ in
            Button("OK") {
                tabViewModel.importSuccessMessage = nil
            }
        } message: { message in
            Text(message)
        }
        .alert("Error", isPresented: .constant(tabViewModel.importErrorMessage != nil), presenting: tabViewModel.importErrorMessage) { _ in
            Button("OK") {
                tabViewModel.importErrorMessage = nil
            }
        } message: { message in
            Text(message)
        }
    }
}

#Preview {
    TabScreenView()
}
