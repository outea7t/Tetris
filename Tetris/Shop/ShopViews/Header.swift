//
//  Header.swift
//  Tetris
//
//  Created by Out East on 03.12.2023.
//

import SwiftUI

struct Header: View {
    
    private let headerColor = Color(#colorLiteral(red: 0.01568627451, green: 0, blue: 0.1803921569, alpha: 1))
    private let strokeColor = Color(#colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 1, alpha: 1))
    
    var body: some View {
        ZStack {
            
            // MARK: Header Rectangle
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 410, height: 140)
                .foregroundStyle(self.headerColor)
            
            RoundedRectangle(cornerRadius: 40)
                .stroke(self.strokeColor, lineWidth: 9)
                .frame(width: 410, height: 140)
                .foregroundStyle(self.headerColor)
                
            
            HStack {
                // MARK: Back Button
                Button {
                    
                } label: {
                    HStack {
                        Image("PointerLeft", bundle: nil)
                            .resizable()
                            .frame(width: 20, height: 33)
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 4, y: 4)
                        
                        PixelText(text: "Back", fontSize: 20, color: self.strokeColor)
                            .padding()
                    }
                    .padding(.leading, 70)
                    
                }
                
                Spacer()
                
                // MARK: Price
                PixelText(text: "\(UserStatistics.moneyCount)", fontSize: 30, color: .white)
                    .padding(.horizontal)
                
                Image("Dollar")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 70)
            }
            .offset(y: 15)
        }
    }
}

#Preview {
    Header()
}
