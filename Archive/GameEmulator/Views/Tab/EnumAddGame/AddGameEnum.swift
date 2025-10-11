//
//  AddGameEnum.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 5/10/25.
//

import SwiftUI

typealias AddGameAction = ((AddGameEnum) -> ())

enum AddGameEnum: Identifiable, CaseIterable, View {
    case left1, left2, add, scan, right1, right2
    var id: Self { self }
    
    var addGameItem: AddGameItem {
        switch self {
        case .add:
                .init(name: "Add Games", Image: "tab_ic_add_game")
        case .scan:
                .init(name: "Scan Folder", Image: "tab_ic_scan_folder")
        case .left1:
                .init(name: "", Image: "")
        case .left2:
                .init(name: "", Image: "")
        case .right1:
                .init(name: "", Image: "")
        case .right2:
                .init(name: "", Image: "")
        }
    }
    
    var body: some View {
        if !addGameItem.name.isEmpty {
            VStack(alignment: .center, spacing: 2) {
                Image(addGameItem.Image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(addGameItem.name)
                    .font(Font.custom("SVN-Determination Sans", size: 10))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 6)
            .padding(.top, 12.5)
            .padding(.bottom, 13.5)
            .frame(width: 68, alignment: .center)
        }
    }
}
