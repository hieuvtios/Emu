//
//  OnboardingScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI

struct OnboardingScreenView: View {
    
    @State private var currentPageIndex: Int = 0
    @State private var showTabView = false
    @State private var showRateView = false
    @State private var showRattingBanner = false
    @State private var showIAPScreenView = false
    
    var body: some View {
        ScrollView {
            TabView(selection: $currentPageIndex) {
                ForEach(OnboardingPageEnum.allCases.indices, id: \.self) {
                    index in
                    
                    let page = OnboardingPageEnum.allCases[index]
                    
                    ZStack {
                        Image(page.bg)
                            .resizable()
                            .ignoresSafeArea()
                        
                        VStack {
                            Spacer()
                            
                            Image(page.img)
                                .resizable()
                                .scaledToFit()
                            
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
                            .padding(.vertical, 20)
                        }
                    }
                    .tag(index)
                }
            }
            .frame(
                width: UIScreen.main.bounds.width ,
                height: UIScreen.main.bounds.height
            )
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .edgesIgnoringSafeArea(.all)
        .background(
            navPayWallView()
        )
        .overlay {
            AppBannerNotification(bannerType: .success, isShowing: $showRattingBanner, onDimiss: {
                showIAPScreenView = true
            })
        }
        .fullScreenCover(isPresented: $showRateView) {
            RatingScreenView(onCompleteRating: {
                showRattingBanner = true
            })
            .background(ClearBackgroundView())
        }
    }
    
    func nextAction() {
        if currentPageIndex < OnboardingPageEnum.allCases.count - 1 {
            currentPageIndex += 1
        } else {
            showRateView = true
        }
    }
    
    @ViewBuilder
    func navPayWallView() -> some View {
        NavigationLink(isActive: $showIAPScreenView) {
            PayWallScreenView(isIapAfterOnboarding: true)
                .navigationTitle("")
                .navigationBarHidden(true)
        } label: {
            EmptyView()
        }
    }
}

#Preview {
    OnboardingScreenView()
}
