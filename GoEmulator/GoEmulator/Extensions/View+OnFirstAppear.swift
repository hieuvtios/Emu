//
//  View+OnFirstAppear.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 18/10/25.
//

import SwiftUI

extension View {
    func onFirstAppear( perform: @escaping () -> Void ) -> some View {
        return self.modifier(OnFirstAppearModifier(perform: perform))
    }
}
struct OnFirstAppearModifier: ViewModifier {
    let perform: () -> Void
    @State private var firstTime: Bool = true
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if firstTime {
                    firstTime = false
                    self.perform()
                }
            }
    }
}
