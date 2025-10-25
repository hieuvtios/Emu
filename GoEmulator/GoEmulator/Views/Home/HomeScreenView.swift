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
        VStack {
            HomeTopBar(title: "Home")
            
            HomeSearchBar(searchText: $homeViewModel.searchText)
            
            HomeGameList()
                .environmentObject(homeViewModel)
                .environmentObject(tabViewModel)
        }
    }
}

#Preview {
    HomeScreenView()
}
