//
//  BottomTabElement.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 4/10/25.
//

import SwiftUI

struct BottomTabElement: View {
    @Binding var tabSelection: AppScreen
    let tab: AppScreen
    
    var body: some View {
        Button {
            tabSelection = tab
        } label: {
            VStack {
                Image(tab.icon_select)
                
                // Caption/12px/Bold
                Text(tab.label)
                    .font(
                        Font.custom("Chakra Petch", size: 12)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(tabSelection == tab ? Color(.blue3) : Color(.grey500))
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    TabScreenView()
}

