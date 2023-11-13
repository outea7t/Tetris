//
//  LoseView.swift
//  Tetris
//
//  Created by Out East on 29.10.2023.
//

import SwiftUI

struct LoseView: View {
    @Environment(\.presentationMode) var presentationMode
    private var backgroundColor = #colorLiteral(red: 0.007843137255, green: 0, blue: 0.09019607843, alpha: 1)
    
    var gainedScore: Int
    var gainedMoney: Int
    
    init(gainedScore: Int, gainedMoney: Int) {
        self.gainedScore = gainedScore
        self.gainedMoney = gainedMoney
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
                EndGameButton(text: "TryAgain", textColor: .white, fontSize: 40)
                    .frame(height: 100)
                    .padding(.bottom, 20)
                
                // MARK: Menu Button
                EndGameButton(text: "Menu", textColor: .white, fontSize: 40)
                    .frame(height: 100)
                Spacer()
            }
        }
    }
}

#Preview {
    LoseView(gainedScore: 26112, gainedMoney: 31)
}
