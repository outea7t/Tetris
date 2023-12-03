//
//  Shop.swift
//  Tetris
//
//  Created by Out East on 26.11.2023.
//

import SwiftUI

struct Shop: View {
    private let backgroundColor = Color(#colorLiteral(red: 0.007843137255, green: 0, blue: 0.09019607843, alpha: 1))
    
    @State private var skins: [Skin] = (0...UserCustomization.maxTetrominoSkinIndex).map { index in
        var isBuyed = UserCustomization.buyedSkinIndexes.contains(index) ? true : false
        var isSelected = UserCustomization.currentTetrominoSkinIndex == index ? true : false
        return Skin(skinID: index, skinPrice: index * 20, isSelected: isSelected, isBuyed: isBuyed)
    }
    
    var body: some View {
        ZStack {
            // MARK: Background Color
            self.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    // MARK: Shop Cards
                    ForEach(self.$skins) { skin in
                        ShopCard(skin: skin)
                        // MARK: Tap Gesture
                        .gesture(
                            TapGesture()
                                .onEnded { value in
                                    if !skin.isBuyed.wrappedValue {
                                        withAnimation(.easeInOut(duration: 1.5)) {
                                            skin.isSelected.wrappedValue.toggle()
                                            skin.isBuyed.wrappedValue = true
                                        }
                                        UserCustomization.buyedSkinIndexes.append(skin.skinID.wrappedValue)
                                        UserCustomization.currentTetrominoSkinIndex = skin.skinID.wrappedValue
                                        
                                        for tempSkin in skins {
                                            if tempSkin.skinID != skin.skinID.wrappedValue {
                                                tempSkin.isSelected = false
                                            }
                                        }
                                    }
                                    if skin.isBuyed.wrappedValue && !skin.isSelected.wrappedValue {
                                        withAnimation(.easeInOut(duration: 1.5)) {
                                            skin.isSelected.wrappedValue.toggle()
                                        }
                                        UserCustomization.currentTetrominoSkinIndex = skin.skinID.wrappedValue
                                    }
                                }
                        )
                    }
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
