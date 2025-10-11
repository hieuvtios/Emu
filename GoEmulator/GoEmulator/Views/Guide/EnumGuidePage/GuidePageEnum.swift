//
//  GuidePageEnum.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

enum GuidePageEnum: String, Identifiable, CaseIterable, View {
    var id: Self { self }
    
    case step = "Step"
    case site = "Site"
    case controller = "Controller"
    
    var body: some View {
        switch self {
        case .step:
            GuideStepScreenView()
        case .site:
            GuideSiteScreenView()
        case .controller:
            GuideControllerScreenView()
        }
    }
}
