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
            ""
        case .console:
            "tab_ic_console_select"
        case .setting:
            "tab_ic_setting_select"
        case .addGame:
            ""
        }
    }
    
    var icon_unselect: String {
        switch self {
        case .home:
            "tab_ic_home_unselect"
        case .guide:
            "tab_ic_guide_unselect"
        case .console:
            "tab_ic_console_unselect"
        case .setting:
            "tab_ic_setting_unselect"
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
            ConsoleScreenView()
        case .setting:
            SettingScreenView()
        case .addGame:
            EmptyView()
        }
    }
}

struct TabScreenView: View {
    
    @StateObject var tabViewModel = TabViewModel()
    
    var body: some View {
        NavigationView {
            TabView(selection: $tabViewModel.tabSelection) {
                ForEach(AppScreen.allCases) { screen in
                    screen.destination
                        .tag(screen as AppScreen?)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(
                AppBackGround()
            )
            .background(
                navigationView()
            )
            .overlay(content: {
                if tabViewModel.isExpanded {
                    Color(.color000000).opacity(0.8)
                        .onTapGesture {
                            tabViewModel.isExpanded = false
                        }
                }
            })
            .overlay(alignment: .bottom) {
                BottomTabView(tabViewModel: tabViewModel, addGameAction: { action in
                    tabViewModel.showDocumentPicker = true
                })
            }
            .sheet(isPresented: $tabViewModel.showDocumentPicker, onDismiss: {}, content: {
                DocumentPicker(documentTypes: [])
            })
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

extension TabScreenView {
    @ViewBuilder
    func navigationView() -> some  View {
        VStack {
            navGuideView()
        }
    }
    
    @ViewBuilder
    func navGuideView() -> some View {
        NavigationLink(isActive: $tabViewModel.showGuideView) {
            GuideScreenView()
                .navigationTitle("")
                .navigationBarHidden(true)
        } label: {
            EmptyView()
        }
    }
}

#Preview {
    TabScreenView()
}
