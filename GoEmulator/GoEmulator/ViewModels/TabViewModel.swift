//
//  TabViewModel.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 4/10/25.
//

import SwiftUI

class TabViewModel: ObservableObject {
    @Published var tabSelection: AppScreen = .home
    
    @Published var isExpanded: Bool = false
    
    @Published var showDocumentPicker = false
    
    @Published var showGuideView = false
    
    @Published var currentSpot: Int? = -1
}
