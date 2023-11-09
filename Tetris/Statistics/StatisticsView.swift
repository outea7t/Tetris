//
//  StatisticsView.swift
//  Tetris
//
//  Created by Out East on 06.11.2023.
//

import SwiftUI
import SpriteKit

struct StatisticsView: View {
    var backdroundAnimationScene: SKScene {
        let scene = BackgroundAnimation()
        scene.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0, blue: 0.09019607843, alpha: 1)
        scene.size = CGSize(width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    private let backButtonColor = #colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 1, alpha: 1)
    var body: some View {
        ZStack {
            GameColor.backgroundColor
                .ignoresSafeArea()
            
            // MARK: Background Animation
            SpriteView(scene: backdroundAnimationScene)
                .ignoresSafeArea()
                .blur(radius: 20)
            
            VStack() {
                // MARK: Back Button
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("PointerLeft", bundle: nil)
                            .resizable()
                            .foregroundStyle(Color(backButtonColor))
                            .frame(width: 17, height: 25)
                        PixelText(text: "Menu", fontSize: 25, color: Color(backButtonColor))
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, 15)
                // MARK: Stats Text
                PixelText(text: "Stats:", fontSize: 65, color: .white)
                    .padding(.top, 35)
                    .padding(.bottom, 23)
                
                // MARK: Divider
                GlowingDivider()
                    .padding(.bottom, 70)
                
//                VStack(alignment: .leading) {
                    // MARK: Max Score
                    PixelText(text: "Max Score:", fontSize: 25, color: .white)
                        .padding(.bottom, 10)
                    
                    PixelText(text: "\(UserStatistics.maxScore)", fontSize: 25, color: .white)
                        .padding(.bottom, 20)
//                        .padding(.leading, 30)
                    
                    // MARK: Short Divider
                    GlowingDivider(isShort: true)
                        .padding(.bottom, 20)
//                        .padding(.leading, -10)
                    
                    // MARK: Buyed Skins Count
                    PixelText(text: "Buyed Skins", fontSize: 25, color: .white)
                        .padding(.bottom, 10)
                    
                    PixelText(text: "\(UserCustomization.countOfBuyedSkins)", fontSize: 25, color: .white)
                        .padding(.bottom, 20)
//                        .padding(.leading, 30)
                    
                    // MARK: Short Divider
                    GlowingDivider(isShort: true)
                        .padding(.bottom, 20)
//                        .padding(.leading, -10)
                    
                    // MARK: Money Count
                    PixelText(text: "Money Count", fontSize: 25, color: .white)
                        .padding(.bottom, 10)
                    
                    PixelText(text: "\(UserCustomization.countOfBuyedSkins)", fontSize: 25, color: .white)
//                        .padding(.leading, 30)
                    
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.leading, 30)
                Spacer()
            }
        }
    }
}

#Preview {
    StatisticsView()
}
