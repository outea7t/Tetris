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
    var skin: Skin
    
    private let backgroundColor = Color(#colorLiteral(red: 0.03529411765, green: 0.02352941176, blue: 0.1607843137, alpha: 1))
    private let buyedBackgroundColor = Color(#colorLiteral(red: 0.05098039216, green: 0.03529411765, blue: 0.2980392157, alpha: 1))
    private let selectedStrokeColor = Color(#colorLiteral(red: 0.4960303903, green: 0.568154037, blue: 1, alpha: 1))
    
    private let startImageName = "ShopSkinTexture-"
    private let strokeGradientColors: [Color] = [
        Color(#colorLiteral(red: 0.4868299365, green: 0.566298604, blue: 1, alpha: 1)),
        Color(#colorLiteral(red: 0.337254902, green: 0.4117647059, blue: 1, alpha: 1)),
        Color(#colorLiteral(red: 0.46964854, green: 0.3869253993, blue: 0.9994549155, alpha: 1)),
        Color(#colorLiteral(red: 0.4868299365, green: 0.566298604, blue: 1, alpha: 1))
    ]
    
    @State private var isAnimated: Bool = false
    
    var body: some View {
        ZStack {
            if self.isSelected {
                // MARK: Cell Shadow
                RoundedRectangle(cornerRadius: 0)
                
                    .frame(width: 500, height: 500)
                    .foregroundStyle(LinearGradient(colors: self.strokeGradientColors,
                                                    startPoint: .top,
                                                    endPoint: .bottom))
                    .rotationEffect(.degrees((self.isAnimated && self.isSelected) ? 0.0 : 360.0))
                    .animation(
                        Animation.easeInOut(duration: 4.0)
                            .repeatForever(autoreverses: false)
                    )
                    .mask {
                        RoundedRectangle(cornerRadius: 40)
                            .frame(width: 270, height: 360)
                            .blur(radius: 22)
                    }
            }
            
            // MARK: Cell Heart
            RoundedRectangle(cornerRadius: 32)
                .frame(width: 250, height: 335)
                .foregroundStyle( Color((self.isBuyed && !self.isSelected) ? self.buyedBackgroundColor : self.backgroundColor)
                .shadow(.inner(color: .black.opacity(0.3),
                               radius: self.isSelected ? 20 : 0,
                               x: self.isSelected ? 30 : 0,
                               y: self.isSelected ? 45 : 0))
                )
            
            if self.isSelected {
                // MARK: Cell Stroke
                RoundedRectangle(cornerRadius: 40)
                    .frame(width: 500, height: 500)
                    .foregroundStyle(LinearGradient(colors: self.strokeGradientColors,
                                                    startPoint: .top,
                                                    endPoint: .bottom))
                    .rotationEffect(.degrees((self.isAnimated && self.isSelected) ? 0.0 : 360.0))
                    .animation(
                        Animation.easeInOut(duration: 4.0)
                            .repeatForever(autoreverses: false)
                    )
                    .mask {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(lineWidth: 15)
                            .frame(width: 265, height: 350)
                        
                    }
            }
            VStack {
                // MARK: Skin Image
                Image("\(self.startImageName)\(self.skin.skinID)", bundle: nil)
                    .resizable()
                    .frame(width: 140, height: 133)
                    .shadow(color: .black.opacity(0.5), radius: 15, x: 15, y: 15)
                    .padding(.top, 40)
                
                Spacer()
                
                // MARK: Skin Price
                HStack {
                    PixelText(text: "\(self.skin.skinPrice)", fontSize: 30, color: .white)
                    
                    Image("Dollar", bundle: nil)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .shadow(color: .black.opacity(0.5), radius: 15, x: 15, y: 15)
                }
                
                Spacer()
            }
            .frame(height: 350)
        }
        .onAppear {
            self.isAnimated.toggle()
        }
        .frame(height: self.isSelected ? 380 : 360)
    }
}

#Preview {
    ShopCard(isBuyed: true, isSelected: true, skin: Skin(skinID: 0, skinPrice: 100))
}
