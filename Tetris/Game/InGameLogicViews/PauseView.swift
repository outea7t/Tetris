//
//  PauseView.swift
//  Tetris
//
//  Created by Out East on 29.10.2023.
//

import SwiftUI

struct PauseView: View {
    @Environment(\.presentationMode) var presentationMode
    private var backgroundColor = #colorLiteral(red: 0.007843137255, green: 0, blue: 0.09019607843, alpha: 1)
    
    var currentScore: Int
    init(currentScore: Int) {
        self.currentScore = currentScore
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
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    EndGameButton(text: "Continue", textColor: .white, fontSize: 40)
                }
                    .padding(.bottom, 20)
                
                // MARK: Menu Button
                EndGameButton(text: "Menu", textColor: .white, fontSize: 40)
                
                Spacer()
            }
        }
    }
}

#Preview {
    PauseView(currentScore: 100)
}
