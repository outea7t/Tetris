//
//  ARGameView.swift
//  Tetris
//
//  Created by Out East on 15.11.2023.
//

import SwiftUI
import ARKit

struct ARGameView: View {
    @Binding var navigationPaths: [Routes]
    
    var body: some View {
        ARGameViewControllerRepresentable()
            .ignoresSafeArea()
    }
}

#Preview {
    ARGameView(navigationPaths: Binding.constant([]))
}
