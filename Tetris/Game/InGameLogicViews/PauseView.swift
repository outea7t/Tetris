//
//  PauseView.swift
//  Tetris
//
//  Created by Out East on 29.10.2023.
//

import SwiftUI

struct PauseView: View {
    private var backgroundColor = #colorLiteral(red: 0.007843137255, green: 0, blue: 0.09019607843, alpha: 1)
    
    var currentScore: Int
    var backgroundOpacity: Double
    private var shouldAddBackgroundBlur: Bool
    
    @Binding var navigationPaths: [Routes]
    
    init(currentScore: Int, backgroundOpacity: Double, navigationPaths: Binding<[Routes]>) {
        self.currentScore = currentScore
        self.backgroundOpacity = backgroundOpacity
        self._navigationPaths = navigationPaths
        
        if backgroundOpacity < 1.0 {
            self.shouldAddBackgroundBlur = true
        } else {
            self.shouldAddBackgroundBlur = false
        }
    }
    
    var body: some View {
        ZStack {
            // MARK: Background
            Color(backgroundColor)
                .ignoresSafeArea()
                .blur(radius: self.shouldAddBackgroundBlur ? 25 : 0)
            
            VStack {
                // MARK: Pause Text
                PixelText(text: "Pause", fontSize: 65, color: .white)
                    .padding(.top, 35)
                    .padding(.bottom, 23)
                
                // MARK: Divider
                GlowingDivider()
                    .padding(.bottom, 70)
                    
                // MARK: Current Score
                PixelText(text: "Current Score:", fontSize: 30, color: .white)
                
                PixelText(text: "\(currentScore)", fontSize: 50, color: .white)
                    .padding(.top, 20)
                
                Spacer()
                
                // MARK: Continue Button
                Button {
                    GameScene.shared.unpauseGame()
                    self.navigationPaths.removeLast()
                } label: {
                    EndGameButton(text: "Continue", textColor: .white, fontSize: 40)
                        .frame(height: 100)
                }
                    .padding(.bottom, 20)
                
                // MARK: Menu Button
                Button {
                    GameScene.shared.clearCells()
                    GameScene.shared.unpauseGame()
                    self.navigationPaths.removeLast()
                    self.navigationPaths.removeLast()
                } label: {
                    EndGameButton(text: "Menu", textColor: .white, fontSize: 40)
                        .frame(height: 100)
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PauseView(currentScore: 100, backgroundOpacity: 1.0, navigationPaths: .constant([]))
}
