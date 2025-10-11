//
//  OnboardingPageEnum.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI

enum OnboardingPageEnum: Identifiable, CaseIterable {
    case ob1, ob2, ob3
    
    var id: Self { self }
    
    var bg: String {
        switch self {
        case .ob1:
            "ob_bg"
        case .ob2:
            "ob_bg"
        case .ob3:
            "ob_bg_2"
        }
    }
    
    var img: String {
        switch self {
        case .ob1:
            "ob_1"
        case .ob2:
            "ob_2"
        case .ob3:
            "ob_3"
        }
    }
    
    var title: String {
        switch self {
        case .ob1:
            "Support various games"
        case .ob2:
            "Customize your console"
        case .ob3:
            "Powerful, smooth experience"
        }
    }
}

