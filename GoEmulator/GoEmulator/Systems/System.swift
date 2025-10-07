//
//  System.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 5/10/25.
//

import SwiftUI
import DeltaCore

enum System: String, CaseIterable
{
    case nes = "NES"
    case genesis = "SEGA"
    case snes = "SNES"
    case n64 = "N64"
    case gbc = "GBC"
    case gba = "GBA"
    case ds = "2DS"
    
//    static var registeredSystems: [System] {
//        let systems = System.allCases.filter { Delta.registeredCores.keys.contains($0.gameType) }
//        return systems
//    }
//    
//    var gameType: DeltaCore.GameType {
//        switch self
//        {
//        case .nes: return .nes
//        case .snes: return .snes
//        case .n64: return .n64
//        case .gbc: return .gbc
//        case .gba: return .gba
//        case .ds: return .ds
//        case .genesis: return .genesis
//        }
//    }
}
