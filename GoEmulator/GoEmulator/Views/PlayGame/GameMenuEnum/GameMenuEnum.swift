//
//  GameMenuEnum.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

enum ButtonType {
    case type1
    case type2
    case type3
}

enum GameMenuEnum {
    case saveState
    case loadState
    case restart
    case cheatCode
    case mute
    case rumble
    case fastForward
    case autoSave
    
    var title: String {
        switch self {
        case .saveState:
            return "Save State"
        case .loadState:
            return "Load State"
        case .restart:
            return "Restart"
        case .cheatCode:
            return "Cheat code"
        case .mute:
            return "Mute"
        case .rumble:
            return "Rumble"
        case .fastForward:
            return "Fast Forward"
        case .autoSave:
            return "Auto Save"
        }
    }
    
    var icon: String {
        switch self {
        case .saveState:
            return "menu_save_state"
        case .loadState:
            return "menu_load_state"
        case .restart:
            return "menu_restart"
        case .cheatCode:
            return "menu_cheat_code"
        case .mute:
            return "menu_mute"
        case .rumble:
            return "menu_rumble"
        case .fastForward:
            return "menu_fast_forward"
        case .autoSave:
            return "menu_save_state"
        }
    }
}
