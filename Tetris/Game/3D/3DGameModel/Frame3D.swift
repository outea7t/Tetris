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
    
    /// размеры рамки
    var frameBottomVolume = SCNVector3(x: 0.125, y: 0.05, z: 0.25)
    
    /// закреплена ли позиция рамки
    /// При обнаружении плоскости пользователь может передвигать рамку, двигая телефон
    /// когда он нажмет на экран, то рамка установится и переменная будет равна true
    var isPositionPinned = false
    
    /// для логики создания рамки
    var wantSetPosition = false
    /// стены рамки (косметическое)
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
        let frameBottomGeometry = SCNBox(width: CGFloat(self.frameBottomVolume.x),
                                         height: CGFloat(self.frameBottomVolume.y),
                                         length: CGFloat(self.frameBottomVolume.z), 
                                         chamferRadius: 0.0)
        
        let frameBottomMaterial = SCNMaterial()
        frameBottomMaterial.diffuse.contents = #colorLiteral(red: 0.4272378087, green: 0, blue: 1, alpha: 1)
        frameBottomGeometry.materials = [frameBottomMaterial]
        
        self.node.geometry = frameBottomGeometry
//        for y in 0...19 {
//            var row = [Cell3D]()
//            for x in 0...9 {
//                
//                let cellPosition = SCNVector3()
//                let cell = Cell3D()
//                row.append(cell)
//            }
//            self.cells.append(row)
//        }
    }
    
    func addFrame(to parentNode: SCNNode, in position: SCNVector3) {
        self.node.position = position
        parentNode.addChildNode(self.node)
    }
}
