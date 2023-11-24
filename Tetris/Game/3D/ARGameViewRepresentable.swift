//
//  ARGameViewRepresentable.swift
//  Tetris
//
//  Created by Out East on 13.11.2023.
//

import Foundation
import SwiftUI

struct ARGameViewControllerRepresentable: UIViewControllerRepresentable {
    static var shared = ARGameViewControllerRepresentable()
    
    /// двигаем текущую фигуру по горизонтали
    func moveHorizontal(touch: DragGesture.Value) {
        ARGameViewController.shared.moveHorizontal(touch: touch)
    }
    
    /// двигаем текущую фигуру по вертикали
    func moveVertical(touch: DragGesture.Value) -> Bool {
        return ARGameViewController.shared.moveVertical(touch: touch)
    }
    
    func onTapGesture() {
        ARGameViewController.shared.onTapGesture()
    }
    
    func pauseGame() {
        ARGameViewController.shared
    }
    func makeUIViewController(context: Context) -> ARGameViewController {
        let gameViewController = ARGameViewController.shared
        return gameViewController
    }

    func updateUIViewController(_ uiViewController: ARGameViewController, context: Context) {
        
    }
}
