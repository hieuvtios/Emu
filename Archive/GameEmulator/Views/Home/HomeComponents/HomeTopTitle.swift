//
//  HomeTopTitle.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct HomeTopTitle: View {
    
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(Font.custom("SVN-Determination Sans", size: 20))
                .foregroundColor(.white)
            
            Spacer()
            
            Button {
                
            } label: {
                Image("home_right_arrow")
            }
        }
      
        
        
    }
}
