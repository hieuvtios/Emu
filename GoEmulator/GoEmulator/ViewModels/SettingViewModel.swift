//
//  SettingViewModel.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

class SettingViewModel: ObservableObject {
    
    @Published var fullScreenOption: FullScreenEnum = .connectWithController
    @Published var showFullScreenOption = false
    
    @Published var playerNumber: Int = 1
    @Published var touchScreenNumber: Int = 1
    @Published var showControllerOption = false
    
    @Published var showAirplayGuide = false
    
    @Published var showReview = false
}
