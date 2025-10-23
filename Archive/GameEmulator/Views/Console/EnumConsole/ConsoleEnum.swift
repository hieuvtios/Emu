//
//  ConsoleEnum.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

enum ConsoleEnum: CaseIterable {
    case allConsole
    case myConsole
    
    var title: String {
        switch self {
        case .allConsole:
            return "All Console"
        case .myConsole:
            return "My Console"
        }
    }
}
