//
//  ARGameView.swift
//  Tetris
//
//  Created by Out East on 13.11.2023.
//

import SwiftUI
import ARKit
import RealityKit


class ARGameView: ARSCNView {
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
}

extension ARGameView: ARSCNViewDelegate {
    
}
