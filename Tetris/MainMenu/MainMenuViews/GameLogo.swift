//
//  Game Logo.swift
//  Tetris
//
//  Created by Out East on 18.10.2023.
//

import SwiftUI

struct GameLogo: View {
    var strokeColor = #colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 1, alpha: 1)
    var backgroundColor = #colorLiteral(red: 0.09019607843, green: 0.1058823529, blue: 0.2509803922, alpha: 1)
    var body: some View {
        ZStack {
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
            
            PixelText(text: "Tetris", fontSize: 65, color: .white)
        }
    }
}

#Preview {
    GameLogo()
}
