//
//  Shop.swift
//  Tetris
//
//  Created by Out East on 26.11.2023.
//

import SwiftUI

struct Shop: View {
    private let backgroundColor = Color(#colorLiteral(red: 0.007843137255, green: 0, blue: 0.09019607843, alpha: 1))
    
    var body: some View {
        ZStack {
            // MARK: Background Color
            self.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    ShopCard(isBuyed: true, isSelected: true, skin: Skin(skinID: 0, skinPrice: 0))
                    
                    ShopCard(isBuyed: true, isSelected: false, skin: Skin(skinID: 1, skinPrice: 0))
                    
                }
                .offset(CGSize(width: 0, height: 120))
            }
            
            
            // MARK: Header
            VStack {
                Header()
                    .offset(y: -5)
                    .ignoresSafeArea()
                    
                Spacer()
            }
            
        }
    }
}

#Preview {
    Shop()
}
