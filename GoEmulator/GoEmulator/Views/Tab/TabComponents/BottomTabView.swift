//
//  BottomTabView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 4/10/25.
//

import SwiftUI

struct BottomTabView: View {
    @ObservedObject var tabViewModel: TabViewModel
    var addGameAction: AddGameAction
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 5)
        LazyVGrid(columns: columns) {
            ForEach(AppScreen.allCases) { tab in
                if tab == .guide {
                    BottomTabElement(tabViewModel: tabViewModel, tab: tab)
                        .addSpotlight(1, text: "")
                } else {
                    BottomTabElement(tabViewModel: tabViewModel, tab: tab)
                }
               
            }
        }
        .padding(.horizontal, 6)
        .background(
            VisualEffectRepresentable(style: .systemUltraThinMaterialDark)
        )
        .cornerRadius(16)
        .overlay {
            SemiCircleTabBar(isExpanded: $tabViewModel.isExpanded, addGameAction: addGameAction)
                .addSpotlight(2, text: "")
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    TabScreenView()
}
