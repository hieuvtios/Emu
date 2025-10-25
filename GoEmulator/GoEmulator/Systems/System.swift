//
//  System.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 5/10/25.
//

import DeltaCore
import NESDeltaCore
import SNESDeltaCore
//import GBCDeltaCore
//import GPGXDeltaCore
import GBADeltaCore
import MelonDSDeltaCore
import N64DeltaCore

enum System: String, CaseIterable
{
    case nes = "NES"
    //case genesis = "SEGA"
    case snes = "SNES"
    case n64 = "N64"
    //case gbc = "GBC"
    case gba = "GBA"
    case ds = "2DS"
    
    static var registeredSystems: [System] {
        let systems = System.allCases.filter { Delta.registeredCores.keys.contains($0.gameType) }
        return systems
    }

    static var allCores: [DeltaCoreProtocol] {
        //return [SNES.core,NES.core, GBC.core, GPGX.core,GBA.core,MelonDS.core,N64.core]
        return [SNES.core,NES.core,GBA.core,MelonDS.core,N64.core]
    }
}

extension System
{
    var localizedName: String {
        switch self
        {
        case .nes: return NSLocalizedString("Nintendo", comment: "")
        case .snes: return NSLocalizedString("Super Nintendo", comment: "")
        case .n64: return NSLocalizedString("Nintendo 64", comment: "")
        //case .gbc: return NSLocalizedString("Game Boy Color", comment: "")
        case .gba: return NSLocalizedString("Game Boy Advance", comment: "")
        case .ds: return NSLocalizedString("Nintendo DS", comment: "")
        //case .genesis: return NSLocalizedString("Sega Genesis", comment: "")
        }
    }

    var localizedShortName: String {
        switch self
        {
        case .nes: return NSLocalizedString("NES", comment: "")
        case .snes: return NSLocalizedString("SNES", comment: "")
        case .n64: return NSLocalizedString("N64", comment: "")
        //case .gbc: return NSLocalizedString("GBC", comment: "")
        case .gba: return NSLocalizedString("GBA", comment: "")
        case .ds: return NSLocalizedString("DS", comment: "")
        //case .genesis: return NSLocalizedString("Genesis (Beta)", comment: "")
        }
    }

    var year: Int {
        switch self
        {
        case .nes: return 1985
        //case .genesis: return 1989
        case .snes: return 1990
        case .n64: return 1996
        //case .gbc: return 1998
        case .gba: return 2001
        case .ds: return 2004
        }
    }
}

extension System
{
    var deltaCore: DeltaCoreProtocol {
        switch self
        {
        case .nes: return NES.core
        case .snes: return SNES.core
        case .n64: return N64.core
        //case .gbc: return GBC.core
        case .gba: return GBA.core
        case .ds: return MelonDS.core
        //case .genesis: return GPGX.core
        }
    }

    var gameType: DeltaCore.GameType {
        switch self
        {
        case .nes: return .nes
        case .snes: return .snes
        case .n64: return .n64
        //case .gbc: return .gbc
        case .gba: return .gba
        case .ds: return .ds
        //case .genesis: return .genesis
        }
    }

    init?(gameType: DeltaCore.GameType)
    {
        switch gameType
        {
        case GameType.nes: self = .nes
        case GameType.snes: self = .snes
        case GameType.n64: self = .n64
        //case GameType.gbc: self = .gbc
        case GameType.gba: self = .gba
        case GameType.ds: self = .ds
        //case GameType.genesis: self = .genesis
        default: return nil
        }
    }
}

extension DeltaCore.GameType
{
    init?(fileExtension: String)
    {
        switch fileExtension.lowercased()
        {
        case "nes": self = .nes
        case "smc", "sfc", "fig": self = .snes
        case "n64", "z64": self = .n64
        //case "gbc", "gb": self = .gbc
        case "gba": self = .gba
        case "ds", "nds": self = .ds
        //case "gen", "bin", "md", "smd": self = .genesis
        default: return nil
        }
    }
}

