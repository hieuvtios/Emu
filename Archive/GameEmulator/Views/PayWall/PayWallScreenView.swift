//
//  PayWallScreenView.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 6/10/25.
//

import SwiftUI
import RevenueCat

struct PayWallScreenView: View {

    @Environment(\.dismiss) var dismiss
    var isIapAfterOnboarding: Bool = false
    
    @State private var showTabView = false
    
    @State var packages: [Package] = []
    
    @State var isShowPolicy = false
    @State var isShowTerm = false
    @State var isPurchaseRunning = false
    @State var isShowAlert = false
    @State var showCloseButton = false
    @State var alert = Alert.init(title: Text(""))
    
    var body: some View {
        ZStack {
            Image("pw_bg")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Spacer()
                    
                    Button {
                        dismissView()
                    } label: {
                        Image("home_ic_close")
                            .padding()
                    }
                }
                .isHidden(!showCloseButton)
                
                Spacer()
                
                FeatureView()
                
                VStack(spacing: 16) {
                    if packages.isEmpty {
                        ProgressView()
                            .tint(.white)
                    } else {
                        ForEach(packages.indices, id: \.self) { index in
                            let package = packages[index]
                            if index == 0 {
                                FreeTrialPurchaseButton(package: package) {
                                    purchase(index: index)
                                }
                            } else {
                                PurchaseButton(package: packages[index], isShowBadge: index > 1 ? true : false) {
                                    purchase(index: index)
                                }
                            }
                        }
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 25)
                
                HStack(spacing: 16) {
                    Button {
                        
                    } label: {
                        // Caption/12px/Bold
                        Text("Cancel Anytime")
                          .font(
                            Font.custom("Chakra Petch", size: 12)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.87, green: 0.96, blue: 1))
                    }
                    
                    Button {
                        
                    } label: {
                        // Caption/12px/Bold
                        Text("Terms and Condition")
                          .font(
                            Font.custom("Chakra Petch", size: 12)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.87, green: 0.96, blue: 1))
                    }
                    
                    Button {
                        
                    } label: {
                        // Caption/12px/Bold
                        Text("Privacy Policy")
                          .font(
                            Font.custom("Chakra Petch", size: 12)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.87, green: 0.96, blue: 1))
                    }
                    
                }
            }
        }
        .background(
            navTabView()
        )
        .onAppear(perform: getPackages)
        .alert(isPresented: $isShowAlert, content: {
            alert
        })
        .overlay(content: {
            if isPurchaseRunning {
                VisualEffectRepresentable(style: .dark).opacity(0.9)
                    .overlay {
                        ProgressView().tint(.white)
                    }
                    .ignoresSafeArea()
            }
        })
        .blockOpenAds(screenName: "PayWall")
    }
}

extension PayWallScreenView {
    func getPackages() {
        Task {
            let results = await RevenueCatManager.shared.getPackages(RevenueCatManager.shared.idOfferings)
            if results.error != nil {
                try await Task.sleep(seconds: 3)
                showCloseButton = true
                return
            }
            self.packages = results.packages.sorted(by: { $0.storeProduct.price > $1.storeProduct.price })
            if let first = packages.first {
                packages.removeFirst()
                packages.append(first)
            }
            print(packages.map({ $0.storeProduct.productIdentifier }))
            try await Task.sleep(seconds: 3)
            showCloseButton = true
        }
    }
    
    func showAlert(title: String, message: String? = nil, dismissButtonTitle: String, action: (() -> Void)? = nil) {
        if let message {
            alert = Alert(title: Text(title), message: Text(message), dismissButton: .cancel(Text(dismissButtonTitle), action: action))
        } else {
            alert = Alert(title: Text(title), dismissButton: .cancel(Text(dismissButtonTitle), action: action))
        }
        
        isShowAlert = true
    }
    
    func purchase(index: Int) {
        isPurchaseRunning = true
        guard !packages.isEmpty else {
            showAlert(title: "Unable to continue",
                      message: "Please select the previous package to continue",
                      dismissButtonTitle: "Cancal", action: { isPurchaseRunning = false })
            return
        }
        let package = packages[index]
        
        RevenueCatManager.shared.purchase(package: package) { status, error in
            if status {
                showAlert(title: "Your purchase successful!", dismissButtonTitle: "Done", action: { dismissView() })
            } else {
                showAlert(title: "Please try again", message: error?.localizedDescription, dismissButtonTitle: "Ok", action: {
                    isPurchaseRunning = false
                })
            }
        }
    }
    
    func restore() {
        isPurchaseRunning = true
        
        RevenueCatManager.shared.restorePurchases { status, error in
            if status == true{
                showAlert(title: "Restore Success", dismissButtonTitle: "Done", action: { dismissView() })
            } else {
                showAlert(title: "No Subscription to Restore",
                          message: "You don’t have any subscriptions. Please purchase a plan first to restore.",
                          dismissButtonTitle: "Cancel", action: { isPurchaseRunning = false })
            }
        }
    }
    
    func dismissView() {
        if isIapAfterOnboarding {
            showTabView = true
        } else {
            dismiss()
        }
    }
}

extension PayWallScreenView {
    @ViewBuilder
    func navTabView() -> some View {
        NavigationLink(isActive: $showTabView) {
            TabScreenView()
                .navigationTitle("")
                .navigationBarHidden(true)
        } label: {
            EmptyView()
        }
    }
}
