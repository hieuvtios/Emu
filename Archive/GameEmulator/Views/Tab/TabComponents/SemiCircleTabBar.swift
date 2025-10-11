//
//----------------------------------------------
// Original project: TabViewDemo
// by  Stewart Lynch on 2025-01-29
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2025 CreaTECH Solutions. All rights reserved.


import SwiftUI

struct SemiCircleTabBar: View {
    @Binding var isExpanded: Bool
    var addGameAction: AddGameAction
    
    var body: some View {
        ZStack {
            let allTabs = AddGameEnum.allCases
            ForEach(allTabs.indices, id: \.self) { index in
                let tabView = allTabs[index]
                let angle = angleForTabButton(at: index, total: allTabs.count)
                let radiusX: CGFloat = 150
                let radiusY: CGFloat = 90
                
                Button {
                    addGameAction(tabView)
                } label: {
                    tabView.body
                        .background(isExpanded ? Color(.color0E3287) : .clear)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(Color(.color779FFF), lineWidth: isExpanded ? 1 : 0)
                        )
                }
                .offset(
                    x: isExpanded ? radiusX * cos(angle.radians) : 0,
                    y: isExpanded ? radiusY * sin(angle.radians) : 0
                )
                .animation(.spring(), value: isExpanded)
            }
            
            AddGameButton(isExpanded: $isExpanded)
        }
        .offset(y: -35)
    }
    
    private func angleForTabButton(at index: Int, total: Int) -> Angle {
        guard total > 1 else {
            return .degrees(-90)
        }
        let totalArc: Double = 180
        let degreesPerItem = totalArc / Double(total - 1)
        let startAngle: Double = -180
        
        let degrees = startAngle + (Double(index) * degreesPerItem)
        return .degrees(degrees)
    }
}

#Preview {
    TabScreenView()
}

