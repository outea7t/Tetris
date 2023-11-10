//
//  Game Logo.swift
//  Tetris
//
//  Created by Out East on 18.10.2023.
//

import SwiftUI

struct GameLogo: View {
    private let strokeColor = Color(#colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 1, alpha: 1))
    
    private let strokeGradientColors = [
        Color(#colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 1, alpha: 1)),
        Color(#colorLiteral(red: 0.6730424762, green: 0.5139406323, blue: 0.998118937, alpha: 1)),
        Color(#colorLiteral(red: 0.2272666097, green: 0.6976506114, blue: 0.9935306907, alpha: 1))
    ]
    private let backgroundColor = Color(#colorLiteral(red: 0.09019607843, green: 0.1058823529, blue: 0.2509803922, alpha: 1))

    @State private var rotation: CGFloat = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .frame(width: 400, height: 400)
                .foregroundStyle(LinearGradient(colors: strokeGradientColors,
                                                startPoint: .top,
                                                endPoint: .bottom))
                .rotationEffect(.degrees(rotation))
                .mask {
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(lineWidth: 8)
                        .frame(width: 360, height: 160)
                        .blur(radius: 10)
                }
            
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 350, height: 140)
                .foregroundStyle(backgroundColor
                    .shadow(.inner(color: .black.opacity(0.3), radius: 10, x: 20, y: 10)))
            
            RoundedRectangle(cornerRadius: 32)
                .frame(width: 400, height: 400)
                .foregroundStyle(LinearGradient(colors: strokeGradientColors,
                                                startPoint: .top,
                                                endPoint: .bottom))
                .rotationEffect(.degrees(rotation))
                .mask {
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(lineWidth: 8)
                        .frame(width: 350, height: 140)
                }
            PixelText(text: "Tetris", fontSize: 65, color: .white)
        }
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    GameLogo()
}

/*
 
 RoundedRectangle(cornerRadius: 30)
     .stroke(Color(backgroundColor).opacity(0.4), lineWidth: 8)
     .frame(width: 350, height: 140)
     .shadow(color: Color(strokeColor), radius: 10)
     .overlay {
         RoundedRectangle(cornerRadius: 30)
             .stroke(Color(strokeColor), lineWidth: 8)
             .background(
                 RoundedRectangle(cornerRadius: 30)
                     .foregroundStyle(Color(backgroundColor)
                         .shadow(.inner(color: .black.opacity(0.5), radius: 15, x: 15, y: 15)))
             )
             .frame(width: 350, height: 140)
     }
 */
