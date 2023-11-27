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
        ARGameViewController.shared?.moveHorizontal(touch: touch)
    }
    
    /// двигаем текущую фигуру по вертикали
    func moveVertical(touch: DragGesture.Value) -> Bool {
        if let result = ARGameViewController.shared?.moveVertical(touch: touch) {
            return result
        }
        return false
    }
    
    func onTapGesture() {
        ARGameViewController.shared?.onTapGesture()
    }
    
    func pauseGame() {
        ARGameViewController.shared?.pauseGame()
    }
    func makeUIViewController(context: Context) -> ARGameViewController {
        ARGameViewController.shared = ARGameViewController()
        if let gameViewController = ARGameViewController.shared {
            return gameViewController
        } else {
            return ARGameViewController()
        }
    }

    func updateUIViewController(_ uiViewController: ARGameViewController, context: Context) {
        
    }
}
