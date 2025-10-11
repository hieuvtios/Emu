//
//  FeatureView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct PayWallFeature: Identifiable {
    let id = UUID().uuidString
    let icon: String
    let text: String
}

struct FeatureView: View {
    
    let features: [PayWallFeature] = [
        PayWallFeature(icon: "pw_game", text: "FREE all legendary games"),
        PayWallFeature(icon: "pw_rotation", text: "Unlimited premium features"),
        PayWallFeature(icon: "pw_no_ad", text: "Remove all interruptive ads"),
        PayWallFeature(icon: "pw_tools", text: "Full Screen play game support")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(features) {
                feature in
                HStack(spacing: 6) {
                    Image(feature.icon)
                    
                    Text(feature.text)
                        .font(Font.custom("SVN-Determination Sans", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    FeatureView()
}
