//
//  PlayFullScreenBottomSheet.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 12/10/25.
//

import SwiftUI

enum FullScreenEnum: CaseIterable {
    case connectWithController
    case connectViaAirplay
    case connectControllerAndAirplay
    
    var text: String {
        switch self {
        case .connectWithController:
            return "Connect with Controller"
        case .connectViaAirplay:
            return "Connect via AirPlay"
        case .connectControllerAndAirplay:
            return "Connect Controller & AirPlay"
        }
    }
}

struct PlayFullScreenBottomSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var fullScreenOption: FullScreenEnum
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    // Title/24px/Bold
                    Text("Play full Screen")
                        .font(Font.custom("SVN-Determination Sans", size: 24))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Button {
                        dismiss()
                    } label: {
                        Image("home_ic_close")
                            .frame(width: 24, height: 24)
                    }
                }
                
                VStack(spacing: 0) {
                    ForEach(FullScreenEnum.allCases, id: \.self) {
                        option in
                        fullScreenItem(option: option)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 23)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.05, green: 0.2, blue: 0.53))
            .cornerRadius(16)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func fullScreenItem(option: FullScreenEnum) -> some View {
        Button {
            fullScreenOption = option
        } label: {
            HStack(alignment: .center, spacing: 8) {
                // Body/16px/Medium
                Text(option.text)
                    .font(
                        Font.custom("Chakra Petch", size: 16)
                            .weight(.medium)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Image(fullScreenOption == option ? "Radio" : "Radio 1")
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    TabScreenView()
}
