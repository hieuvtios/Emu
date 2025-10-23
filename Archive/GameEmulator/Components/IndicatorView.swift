//
//  IndicatorView.swift
//  Template-Base-iOS
//
//  Created by Infinity_IOS_01 on 10/8/24.
//

import SwiftUI

struct IndicatorView: View {
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                Spacer()
            }
            .frame(width: screenSize.width)
        }
        .background(VisualEffectRepresentable(style: .dark).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/))
        .ignoresSafeArea()
    }
}

struct Indicator_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView()
    }
}
