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
    
    @Binding var navigationPaths: [Routes]
    
    init(currentScore: Int, navigationPaths: Binding<[Routes]>) {
        self.currentScore = currentScore
        self._navigationPaths = navigationPaths
    }
    
    var body: some View {
        ZStack {
            Color(backgroundColor)
                .ignoresSafeArea()
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
    PauseView(currentScore: 100, navigationPaths: .constant([]))
}
