//
//  View+Ad+Extension.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 18/10/25.
//

import SwiftUI

extension View {
    func size(_ size: CGSize) -> some View {
        return self.frame(width: size.width, height: size.height)
    }
    
    func minimumSize(_ size: CGSize) -> some View {
        return self.frame(minWidth: size.width, minHeight: size.height)
    }
}
