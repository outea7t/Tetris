//
//  ShopCard.swift
//  Tetris
//
//  Created by Out East on 26.11.2023.
//

import SwiftUI

struct ShopCard: View {
    var isBuyed: Bool
    var isSelected: Bool
    
    private let backgroundColor = Color(#colorLiteral(red: 0.03935023397, green: 0.008918602951, blue: 0.3424890637, alpha: 1))
    private let buyedBackgroundColor = Color(#colorLiteral(red: 0.1214722916, green: 0.2701452374, blue: 0.5730941296, alpha: 1))
    private let selectedStrokeColor = Color(#colorLiteral(red: 0.4960303903, green: 0.568154037, blue: 1, alpha: 1))
    
    private let textColor = Color(#colorLiteral(red: 0.04141693562, green: 0.006711484864, blue: 0.3404637873, alpha: 1))
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: isSelected ? 320 : 300, height: isSelected ? 420 : 400)
                .foregroundStyle(selectedStrokeColor)
            
            RoundedRectangle(cornerRadius: 40)
                .frame(width: 300, height: 400)
                .foregroundStyle(isBuyed ? buyedBackgroundColor : backgroundColor)
                .overlay {
                    VStack {
                        Image("DetectedPlane", bundle: nil)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding(.top, 30)
                        
                        Spacer()
                        
                        if !self.isBuyed {
                            PixelText(text: "100", fontSize: 30, color: .white)
                                .padding(.bottom, 30)
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: 250, height: 50)
                                .foregroundStyle(selectedStrokeColor)
                                .overlay {
                                    PixelText(text: "buy", fontSize: 30, color: self.textColor)
                                }
                                .padding(.bottom, 20)
                        }
                    }
                }
            
        }
    }
}

#Preview {
    ShopCard(isBuyed: true, isSelected: true)
}
