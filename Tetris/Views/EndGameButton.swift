//
//  EndGameButton.swift
//  Tetris
//
//  Created by Out East on 05.11.2023.
//

import SwiftUI

struct EndGameButton: View {
    private let buttonForegroundColor = #colorLiteral(red: 0.4868299365, green: 0.566298604, blue: 1, alpha: 1)
    private let buttonBackgroundColor = #colorLiteral(red: 0.09019607843, green: 0.1058823529, blue: 0.2509803922, alpha: 1)
    
    var text: String
    var textColor: Color
    var fontSize: CGFloat
    
    var body: some View {
        ZStack {
            Capsule()
                .stroke(Color(buttonBackgroundColor).opacity(0.4), lineWidth: 8)
                .frame(width: 311, height: 86)
                .shadow(color: Color(buttonForegroundColor), radius: 10)
                .overlay {
                    Capsule()
                        .stroke(Color(buttonForegroundColor), lineWidth: 8)
                        .background(
                            Capsule()
                                .foregroundStyle(Color(buttonBackgroundColor)
                                    .shadow(.inner(color: .black.opacity(0.5), radius: 15, x: 15, y: 15)))
                        )
                        .frame(width: 311, height: 86)
                }
            
            PixelText(text: text, fontSize: fontSize, color: textColor)
        }
    }
}

#Preview {
    EndGameButton(text: "Hello", textColor: .white, fontSize: 50)
}
