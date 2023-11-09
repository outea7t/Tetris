//
//  GlowingDivider.swift
//  Tetris
//
//  Created by Out East on 05.11.2023.
//

import SwiftUI

struct GlowingDivider: View {
    private let dividerColor = #colorLiteral(red: 0.4868299365, green: 0.566298604, blue: 1, alpha: 1)
    var isShort = false
    
    init(isShort: Bool = false) {
        self.isShort = isShort
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .frame(width: isShort ? 241 : 380, height: 5)
                .foregroundStyle(Color(dividerColor).opacity(1))
                .blur(radius: 6)
            RoundedRectangle(cornerRadius: 100)
                .frame(width: isShort ? 220 : 366, height: 3)
                .foregroundStyle(Color(dividerColor))
                .shadow(color: Color(dividerColor).opacity(0.4), radius: 6, x: 0, y: 0)
        }
    }
}

#Preview {
    GlowingDivider()
}
