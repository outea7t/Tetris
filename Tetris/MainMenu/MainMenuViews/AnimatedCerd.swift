//
//  AnimatedCerd.swift
//  Tetris
//
//  Created by Out East on 10.11.2023.
//

import SwiftUI

struct AnimatedCerd: View {
    private let backgroundColor = Color(#colorLiteral(red: 0, green: 0.08983967453, blue: 0.2765570879, alpha: 1))
    private let topGradientColor = Color(#colorLiteral(red: 0.0393868424, green: 0.1003128812, blue: 1, alpha: 1))
    private let bottomGradientColor = Color(#colorLiteral(red: 0.9646180272, green: 0.4938128591, blue: 0.9997724891, alpha: 1))
    
    @State var rotation: CGFloat = 0
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 260, height: 440)
                .foregroundStyle(backgroundColor)
            
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .frame(width: 520, height: 520)
                .foregroundStyle(LinearGradient(colors: [topGradientColor, bottomGradientColor],
                                                startPoint: .top,
                                                endPoint: .bottom))
                .rotationEffect(.degrees(rotation))
                .mask {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(lineWidth: 10)
                        .frame(width: 260, height: 440)
                        
                }
            
        }
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                self.rotation = 360
            }
        }
    }
        
}

#Preview {
    AnimatedCerd()
}
