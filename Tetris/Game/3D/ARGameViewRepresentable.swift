//
//  ARGameViewRepresentable.swift
//  Tetris
//
//  Created by Out East on 13.11.2023.
//

import Foundation
import SwiftUI

struct ARGameViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ARGameViewController {
        let gameViewController = ARGameViewController()
        print("Entered makeUIViewController")
        return gameViewController
    }

    func updateUIViewController(_ uiViewController: ARGameViewController, context: Context) {
        
    }
}
