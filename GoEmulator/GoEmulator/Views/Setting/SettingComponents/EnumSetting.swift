//
//  EnumSetting.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

enum EnumSetting {
    case directory
    case airPlayscreen
    case fullScreen
    case controller
    case manageSub
    case term
    case privacy
    case review
    
    var icon: String {
        switch self {
        case .directory:
            return "setting_ic_cloud"
        case .airPlayscreen:
            return "setting_ic_air_play_screen"
        case .fullScreen:
            return "setting_ic_full_screen"
        case .controller:
            return "setting_ic_controller"
        case .manageSub:
            return "setting_ic_manage_sub"
        case .term:
            return "setting_ic_term"
        case .privacy:
            return "setting_ic_privacy"
        case .review:
            return "setting_ic_review_app"
        }
    }
    
    var title: String {
        switch self {
        case .directory:
            return "Directory"
        case .airPlayscreen:
            return "AirPlay  Screen"
        case .fullScreen:
            return "Full screen"
        case .controller:
            return "Controller"
        case .manageSub:
            return "Manage subscriptions"
        case .term:
            return "Term & Conditions"
        case .privacy:
            return "Privacy policy"
        case .review:
            return "Review app"
        }
    }
    
    var subTitle: String {
        switch self {
        case .directory:
            return "Drive/Games/ GBA"
        case .airPlayscreen:
            return ""
        case .fullScreen:
            return ""
        case .controller:
            return ""
        case .manageSub:
            return ""
        case .term:
            return ""
        case .privacy:
            return ""
        case .review:
            return ""
        }
    }
}
