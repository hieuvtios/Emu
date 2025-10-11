////
////  AddGameItemView.swift
////  GoEmulator
////
////  Created by Đỗ Việt on 5/10/25.
////
//
//import SwiftUI
//
//struct AddGameItemView: View {
//    @Binding var isExpanded: Bool
//    var addGameItem: AddGameItem
//    
//    var body: some View {
//        VStack(alignment: .center, spacing: 2) {
//            Image(addGameItem.Image)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 24, height: 24)
//            
//            Text(addGameItem.name)
//                .font(Font.custom("SVN-Determination Sans", size: 10))
//                .multilineTextAlignment(.center)
//                .foregroundColor(.white)
//        }
//        .padding(.horizontal, 6)
//        .padding(.top, 12.5)
//        .padding(.bottom, 13.5)
//        .frame(width: 68, alignment: .center)
//        .background(Color(.color0E3287))
//        .cornerRadius(8)
//        .overlay(
//            RoundedRectangle(cornerRadius: 8)
//                .inset(by: 0.5)
//                .stroke(Color(.color779FFF), lineWidth: 1)
//        )
//    }
//}
//
//#Preview {
//    AddGameItemView()
//}
