//
//  RatingScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI

struct RatingScreenView: View {
    @State var showRattingBanner = true
    @State var rating: Int = 5
    var max: Int = 5
    
    var desription: String {
        switch rating {
        case 1: return "Terrible experience"
        case 2: return "Needs improvement"
        case 3: return "Good but not perfect"
        case 4: return "It's okay to play"
        case 5: return "The best we can get"
        default:
            return ""
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {            
            Rectangle()
                .fill(.black.opacity(0.8))
                .shadow(color: .black.opacity(0.25), radius: 7.5, x: 0, y: 4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("Rate this app")
                        .font(Font.custom("SVN-Determination Sans", size: 22))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("How would you rate our app experience?")
                        .font(Font.custom("SVN-Determination Sans", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                }
                
                starRateView()
                
                Text(desription)
                    .font(Font.custom("SVN-Determination Sans", size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.94, green: 0.69, blue: 0.98))
                
                AppButton(title: "RATE ON PLAY") {
                    
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 64)
            .frame(height: 350, alignment: .bottom)
            .background(Color(red: 0.05, green: 0.2, blue: 0.53))
            .cornerRadius(16, corners: [.topLeft, .topRight])
            .overlay(alignment: .top) {
                Image("image 2003")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 168, height: 168)
                    .position(x: 195, y:-13)
            }
            .background(alignment: .top) {
                Image("Group 34047")
                    .resizable()
                    .scaledToFit()
                    .position(x: 195, y:-13)
            }
            
//            AppBannerNotification(title: "Thank for you feedback", subTitle: "We will improve to enhance the quality")
//                .frame(maxHeight: .infinity, alignment: .top)
//                .padding(.top, 60)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func starRateView() -> some View {
        HStack(alignment: .top, spacing: 12) {
            ForEach(1...max, id: \.self) { index in
                ZStack {
                    if rating == max && index == max {
                        Star(type: .max)
                    } else {
                        Star(type: index <= rating ? .select : .unselect)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        rating = index
                    }
                }
            }
        }
    }
}

#Preview {
    RatingScreenView()
}
