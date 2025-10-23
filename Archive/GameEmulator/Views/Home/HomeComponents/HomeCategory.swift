//
//  HomeCategory.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 7/10/25.
//

import SwiftUI

struct HomeCategory: View {
    
    @State var categoryCurrentIndex = -1
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    categoryButton(index: -1, title: "All") {
                        scrollToIndex(index: -1, proxy: proxy)
                    }
                    .id("-1")
                    
                    ForEach(System.allCases.indices, id: \.self) { index in
                        categoryButton(index: index, title: System.allCases[index].rawValue) {
                            scrollToIndex(index: index, proxy: proxy)
                        }
                        .id("\(index)")
                    }
                }
            }
        }
        .frame(height: 32)
    }
    
    @ViewBuilder
    func categoryButton(index: Int, title: String, onTapAction: @escaping () -> ()) -> some View {
        Button {
            onTapAction()
        } label: {
            Text(title)
              .font(
                Font.custom("Chakra Petch", size: 16)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(categoryCurrentIndex == index ? Color(red: 0.54, green: 0.09, blue: 0.61) : Color(red: 0.77, green: 0.84, blue: 0.99))
              .padding(.horizontal, 16)
              .padding(.vertical, 2)
              .frame(height: 32, alignment: .center)
              .background(categoryCurrentIndex == index ? Color(red: 0.94, green: 0.69, blue: 0.98) : .clear)
              .cornerRadius(42)
        }
    }
    
    func scrollToIndex(index: Int, proxy: ScrollViewProxy) {
        withAnimation {
            categoryCurrentIndex = index
            proxy.scrollTo("\(index)")
        }
    }
}

#Preview {
    HomeCategory()
}
