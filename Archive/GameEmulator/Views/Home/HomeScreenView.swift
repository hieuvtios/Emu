//
//  HomeScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 3/10/25.
//

import SwiftUI

struct HomeScreenView: View {

    @StateObject var homeViewModel = HomeViewModel()
    @EnvironmentObject var tabViewModel: TabViewModel

    var body: some View {
        ZStack {
            AppBackGround()

            VStack {
                HomeTopBar()

                HomeSearchBar(searchText: $homeViewModel.searchText)

                HomeGameList()
                    .environmentObject(homeViewModel)
                    .environmentObject(tabViewModel)
            }
        }
    }
}

#Preview {
    HomeScreenView()
        .environmentObject(TabViewModel())
}
