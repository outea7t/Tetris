//
//  ARGameView.swift
//  Tetris
//
//  Created by Out East on 13.11.2023.
//

import SwiftUI
import ARKit
import RealityKit


class ARGameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return []
    }
    
}

extension ARGameViewController: ARSCNViewDelegate {
    
}

extension ARGameViewController: SCNPhysicsContactDelegate {
    
}
