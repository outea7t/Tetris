//
//  ARLoseView.swift
//  Tetris
//
//  Created by Out East on 24.11.2023.
//

import SwiftUI

struct ARLoseView: View {
    private var backgroundColor = #colorLiteral(red: 0.007843137255, green: 0, blue: 0.09019607843, alpha: 1)
    
    var gainedScore: Int
    var gainedMoney: Int
    
    @Binding var navigationPaths: [Routes]
    
    init(gainedScore: Int, gainedMoney: Int, navigationPaths: Binding<[Routes]>) {
        self.gainedScore = gainedScore
        self.gainedMoney = gainedMoney
        self._navigationPaths = navigationPaths
        UserStatistics.maxScore = max(UserStatistics.maxScore, gainedScore)
        UserStatistics.moneyCount += gainedMoney
    }
    
    var body: some View {
        ZStack {
            Color(backgroundColor)
                .ignoresSafeArea()
            
            VStack {
                // MARK: Game Over Text
                PixelText(text: "Game", fontSize: 70, color: .white)
                    .padding(.trailing, 100)
                    .padding(.bottom, 5)
                
                PixelText(text: "Over!", fontSize: 70, color: .white)
                    .padding(.leading, 100)
                    .padding(.bottom)
                
                // MARK: Diveder
                GlowingDivider()
                    .padding(.bottom, 20)
                
                // MARK: Gained Score
                PixelText(text: "Score", fontSize: 30, color: .white)
                
                PixelText(text: "\(gainedScore)", fontSize: 50, color: .white)
                    .padding(.top, 20)
                
                // MARK: Gained Money
                PixelText(text: "+\(gainedMoney) T", fontSize: 30, color: .white)
                    .padding(.top, 30)
                
                Spacer()
                
                // MARK: Try Again Button
                Button {
                    self.navigationPaths.removeLast()
                } label: {
                    EndGameButton(text: "TryAgain", textColor: .white, fontSize: 40)
                        .frame(height: 100)
                        .padding(.bottom, 20)
                }
                
                // MARK: Menu Button
                Button {
                    ARGameViewController.shared?.resetGame()
                    ARGameViewController.shared?.unpauseGame()
                    ARGameViewController.shared = nil  
                    self.navigationPaths.removeAll()
                } label: {
                    EndGameButton(text: "Menu", textColor: .white, fontSize: 40)
                        .frame(height: 100)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ARLoseView(gainedScore: 26112, gainedMoney: 31, navigationPaths: Binding.constant([]))
}
