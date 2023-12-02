//
//  EndGameButton.swift
//  Tetris
//
//  Created by Out East on 05.11.2023.
//

import SwiftUI

struct EndGameButton: View {
    private let buttonForegroundColor = Color(#colorLiteral(red: 0.4868299365, green: 0.566298604, blue: 1, alpha: 1))
    private let buttonBackgroundColor = Color(#colorLiteral(red: 0.09019607843, green: 0.1058823529, blue: 0.2509803922, alpha: 1))
    private let strokeGradientColors = [
        Color(#colorLiteral(red: 0.4868299365, green: 0.566298604, blue: 1, alpha: 1)),
        Color(#colorLiteral(red: 0.3389918506, green: 0.4124396443, blue: 1, alpha: 1)),
        Color(#colorLiteral(red: 0.46964854, green: 0.3869253993, blue: 0.9994549155, alpha: 1)),
        Color(#colorLiteral(red: 0.4868299365, green: 0.566298604, blue: 1, alpha: 1))
    ]
    var text: String
    var textColor: Color
    var fontSize: CGFloat
    
    @State private var rotation: CGFloat = 0
    
    @State private var isAnimating: Bool = false
    var body: some View {
        ZStack {
            // MARK: Blurred Capsule
            Capsule()
                .frame(width: 400, height: 400)
                .foregroundStyle(LinearGradient(colors: strokeGradientColors,
                                                startPoint: .top,
                                                endPoint: .bottom
                                               ))
                .rotationEffect(.degrees(self.isAnimating ? 0 : 360))
                .animation(
                    Animation.easeInOut(duration: 4.0)
                        .repeatForever(autoreverses: false)
                        
                )
                .mask {
                    Capsule()
                        .stroke(lineWidth: 9)
                        .frame(width: 335, height: 110)
                        .blur(radius: 10)
                }
            
            // MARK: Background Capsule
            Capsule()
                .frame(width: 311, height: 86)
                .foregroundStyle(buttonBackgroundColor
                    .shadow(.inner(color: .black.opacity(0.5), radius: 10, x: 10, y: 5)))
            
            // MARK: Stroke Capsule
            RoundedRectangle(cornerRadius: 0)
                .frame(width: 330, height: 400)
                .foregroundStyle(LinearGradient(colors: strokeGradientColors,
                                                startPoint: .top,
                                                endPoint: .bottom
                                               ))
                .rotationEffect(.degrees(self.isAnimating ? 0 : 360))
                .animation(
                    Animation.easeInOut(duration: 4.0)
                        .repeatForever(autoreverses: false)
                        
                )
                .mask {
                    Capsule()
                        .stroke(lineWidth: 9)
                        .frame(width: 320, height: 95)
                }
            
            PixelText(text: text, fontSize: fontSize, color: textColor)
        }
        .onAppear {
            isAnimating.toggle()
        }
    }
}

#Preview {
    EndGameButton(text: "Hello", textColor: .white, fontSize: 50)
}

/* Capsule()
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
 */
