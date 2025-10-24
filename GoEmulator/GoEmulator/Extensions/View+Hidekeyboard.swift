//
//  View+Hidekeyboard.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 24/10/25.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
