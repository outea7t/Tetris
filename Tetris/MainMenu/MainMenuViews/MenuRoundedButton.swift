//
//  MenuRoundedButton.swift
//  Tetris
//
//  Created by Out East on 18.10.2023.
//

import SwiftUI

struct MenuRoundedButton: View {
    
    let foregroundColor: Color
    let backgroundColor: Color
    let iconName: String
    let size: CGFloat
    init(foregroundColor: Color = Color(#colorLiteral(red: 0.5803921569, green: 0.1647058824, blue: 1, alpha: 1)), backgroundColor: Color = Color(#colorLiteral(red: 0.137254902, green: 0.03921568627, blue: 0.2352941176, alpha: 1)), iconName: String, size: CGFloat = 100) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.iconName = iconName
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(backgroundColor).opacity(0.4), lineWidth: 6)
                .frame(width: size, height: size)
                .shadow(color: Color(foregroundColor), radius: 10)
                .overlay {
                    Circle()
                        .stroke(Color(foregroundColor), lineWidth: 6)
                        .background(
                            Circle()
                                .foregroundStyle(Color(backgroundColor)
                                    .shadow(.inner(color: .black.opacity(0.5), radius: 15, x: 15, y: 15)))
                        )
                        .frame(width: size, height: size)
                }
            
            Image(systemName: self.iconName)
                .resizable()
                .frame(width: size*0.6, height: size*0.6)
                .shadow(color: .black.opacity(0.5),
                        radius: 3, x: 2, y: 4)
                .foregroundStyle(Color(#colorLiteral(red: 0.9587634206, green: 0.8642501235, blue: 1, alpha: 1))
                    .shadow(.inner(color: .black.opacity(0.3), radius: 3, x: -3, y: -3))
                )
        }
    }
}

/*
 Image(systemName: self.iconName)
     .frame(width: 50, height: 50)
     .font(.system(size: 40))
     .shadow(color: .black.opacity(0.5),
             radius: 3, x: 2, y: 4)
     .foregroundStyle(Color(#colorLiteral(red: 0.9587634206, green: 0.8642501235, blue: 1, alpha: 1)))
 */
#Preview {
    MenuRoundedButton(iconName: "star.fill")
}
