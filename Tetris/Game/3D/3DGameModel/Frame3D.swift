//
//  Frame3D.swift
//  Tetris
//
//  Created by Out East on 13.11.2023.
//

import Foundation
import SceneKit

enum WallType: Int {
    case topWall
    case leftWall
    case bottomWall
    case rightWall
    case maxWallIndex
}
class Frame3D {
    var node: SCNNode
    
    var cells = [[Cell3D]]()
    
    private var walls = [SCNNode]()
    
    /// константа для высчитывания размера рамки
    private let wallSizeConstants = SCNVector3(0.1, 0.1, 0.1)
    /// константа для расстояния между ячейками
    private let cellSpaceConstant = SCNVector3()
    
    /// скорость падения тетромино
    private var tetrominoSpeed: Double = 1/1
    /// фигуры, которые выпадали игроку
    var shapes = [Tetromino]()
    /// следующие фигуры
    var nextTetrominos = [Tetromino]()
    /// задержка, перед закреплением детали
    /// чтобы пользователь мог двигать ее в последний момент
    private var isDelaying = false
    
    init() {
        self.node = SCNNode()
        
        for _ in 0..<WallType.maxWallIndex.rawValue {
            let geometry = SCNBox(width: CGFloat(self.wallSizeConstants.x),
                                  height: CGFloat(self.wallSizeConstants.y),
                                  length: CGFloat(self.wallSizeConstants.z),
                                  chamferRadius: 0.1)
            var wallNode = SCNNode(geometry: geometry)
        }
        
        for y in 0...19 {
            var row = [Cell3D]()
            for x in 0...9 {
                
                let cellPosition = SCNVector3()
                let cell = Cell3D()
                row.append(cell)
            }
            self.cells.append(row)
        }
    }
}
