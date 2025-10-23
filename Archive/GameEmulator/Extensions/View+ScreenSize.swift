//
//  View+ScreenSize.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 18/10/25.
//

import SwiftUI

extension View {
    var screenSize: CGSize { UIScreen.main.bounds.size }
    
    func frameFullScreen() -> some View {
        self.frame(width: screenSize.width, height: screenSize.height)
    }
}
