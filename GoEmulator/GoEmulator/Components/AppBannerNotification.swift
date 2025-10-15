//
//  AppBannerNotification.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI

enum BannerEnum {
    case success
    case error
    case warning
    case info
    
    var icon: String {
        switch self {
        case .success:
            return "banner_ic_feedback"
        case .error:
            return "banner_ic_error"
        case .warning:
            return "banner_ic_warning"
        case .info:
            return "banner_ic_info"
        }
    }
    
    var title: String {
        switch self {
        case .success:
            return "Thank for you feedback"
        case .error:
            return "Error"
        case .warning:
            return "Warning"
        case .info:
            return "Infor"
        }
    }
    
    var subTitle: String {
        switch self {
        case .success:
            return "We will improve to enhance the quality"
        case .error:
            return "Order Placed Successfully. You can check order delivery status."
        case .warning:
            return "Order Placed Successfully. You can check order delivery status."
        case .info:
            return "Order Placed Successfully. You can check order delivery status."
        }
    }
    
    var color: Color {
        switch self {
        case .success:
            return Color(hex: "#00CC99")
        case .error:
            return Color(hex: "#EB5757")
        case .warning:
            return Color(hex: "#F2C94C")
        case .info:
            return Color(hex: "#5458F7")
        }
    }
}

struct AppBannerNotification: View {
    let bannerType: BannerEnum
    @Binding var isShowing: Bool
    var onDimiss: (() -> ())?
    
    var body: some View {
        ZStack(alignment: .top) {
            if isShowing {
                Color.black.opacity(0.00001).ignoresSafeArea()
                
                HStack(spacing: 14) {
                    Image(bannerType.icon)
                    
                    VStack(spacing: 0) {
                        // Body/16px/Bold
                        Text(bannerType.title)
                            .font(
                                Font.custom("Chakra Petch", size: 16)
                                    .weight(.bold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.8, blue: 0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Caption/12px/Regular
                        Text(bannerType.subTitle)
                            .font(Font.custom("Chakra Petch", size: 12))
                            .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                }
                .padding(.leading, 18)
                .frame(height: 72)
                .background(Color(red: 0.96, green: 1, blue: 0.99))
                .cornerRadius(7.58397)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(bannerType.color)
                        .foregroundColor(.clear)
                        .frame(width: 4, height: 72)
                        .cornerRadius(3.79198)
                }
                .padding(.horizontal, 20)
                .transition(.move(edge: .top))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.easeInOut, value: isShowing)
        .onChange(of: isShowing) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.onDimiss?()
                }
            }
        }
    }
}

