//
//  SettingItem.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 11/10/25.
//

import SwiftUI

struct SettingItem: View {
    
    let item: EnumSetting
    let onTapAction: () -> ()
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(item.icon)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(
                        Font.custom("Inter", size: 14)
                            .weight(.medium)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                if !item.subTitle.isEmpty {
                    Text(item.subTitle)
                        .font(Font.custom("SVN-Determination Sans", size: 12))
                        .foregroundColor(Color(red: 0.13, green: 0.77, blue: 0.37))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.07, green: 0.24, blue: 0.63).opacity(0.5))
        .cornerRadius(12)
        .onTapGesture {
            onTapAction()
        }
    }
}
