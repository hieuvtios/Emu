//
//  BottomTabElement.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 4/10/25.
//

import SwiftUI

struct BottomTabElement: View {
    @ObservedObject var tabViewModel: TabViewModel
    let tab: AppScreen
    
    var body: some View {
        Button {
            if tab == .guide {
                tabViewModel.showGuideView = true
            } else {
                tabViewModel.tabSelection = tab
            }
        } label: {
            VStack {
                Image(tabViewModel.tabSelection == tab ? tab.icon_select : tab.icon_unselect)
                
                // Caption/12px/Bold
                Text(tab.label)
                    .font(
                        Font.custom("Chakra Petch", size: 12)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(tabViewModel.tabSelection == tab ? Color(.blue3) : Color(.grey500))
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    TabScreenView()
}

