//
//  OnboardingScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI

struct OnboardingScreenView: View {
    
    @State private var currentPageIndex: Int = 0
    
    var body: some View {
        TabView(selection: $currentPageIndex) {
            ForEach(OnboardingPageEnum.allCases.indices, id: \.self) {
                index in
                
                let page = OnboardingPageEnum.allCases[index]
                
                ZStack {
                    Image(page.bg)
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack {
                        Image(page.img)
                            .resizable()
                            .scaledToFit()
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 20) {
                            HStack(alignment: .top, spacing: 8) {
                                ForEach(OnboardingPageEnum.allCases.indices, id: \.self) { pageIndicatorIndex in
                                    Image(currentPageIndex == pageIndicatorIndex ? "ob_page_select" : "ob_page_unselect")
                                }
                            }
                            
                            Text(page.title)
                                .font(Font.custom("SVN-Determination Sans", size: 36))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            
                            AppButton(title: currentPageIndex == OnboardingPageEnum.allCases.count - 1 ? "LET’S PLAY" : "NEXT") {
                                withAnimation {
                                    nextAction()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
    
    func nextAction() {
        if currentPageIndex < OnboardingPageEnum.allCases.count - 1 {
            currentPageIndex += 1
        } else {
            
        }
    }
}

#Preview {
    OnboardingScreenView()
}
