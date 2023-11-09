//
//  PixelText.swift
//  Tetris
//
//  Created by Out East on 05.11.2023.
//

import SwiftUI

struct PixelText: View {
    
    var text: String
    var fontSize: CGFloat
    var color: Color
    
    var body: some View {
        Text(text)
            .font(.custom("04b", size: fontSize))
            .foregroundStyle(color
                .shadow(
                    .inner(color: .black.opacity(0.3), radius: fontSize/25, x: -fontSize/25, y: -fontSize/25)
                )
            )
    }
}

#Preview {
    PixelText(text: "Hello", fontSize: 50, color: .white)
}
