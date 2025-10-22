//
//  TourguideEnum.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 22/10/25.
//

import SwiftUI

enum TourguideEnum: Identifiable, CaseIterable, View {
    var id: Self { self }
    
    case step1
    case step2
    case step3
    case step4
    
    var body: some View {
        switch self {
        case .step1:
            TourguideStep1View()
        case .step2:
            TourguideStep2View()
        case .step3:
            TourguideStep3View()
        case .step4:
            TourguideStep4View()
        }
    }
    
}
