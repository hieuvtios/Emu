//
//  Star.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI

enum StarEnum: String {
    case max = "Group 34112"
    case select = "Звезда_Star 1"
    case unselect = "Звезда_Star"
}

struct Star: View {
    var type: StarEnum

    var body: some View {
        Image(type.rawValue)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40, alignment: .center)
    }
}
