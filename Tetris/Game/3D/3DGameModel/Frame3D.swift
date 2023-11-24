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
    var frameBottomVolume = SCNVector3(x: 0.125, y: 0.01, z: 0.25)
    
    /// закреплена ли позиция рамки
    /// При обнаружении плоскости пользователь может передвигать рамку, двигая телефон
    /// когда он нажмет на экран, то рамка установится и переменная будет равна true
    var isPositionPinned = false {
        willSet {
            print(newValue, " FUCK ")
        }
    }
    
    /// для логики создания рамки
    var wantSetPosition = false
    
    /// фигуры, которые выпадали игроку
    var shapes = [Tetromino]()
    /// следующие фигуры
    var nextTetrominos = [Tetromino]()
    
    /// скорость падения тетромино
    private var tetrominoSpeed: Double = 1/1
    
    private let spaceConstant = SCNVector3(x: 0.03/10, y: 0.03/10, z: 0.0)
    private let cellOffset = SCNVector3(x: 0.07/10, y: 0.07/10, z: 0.0)
    
    /// стены рамки (косметическое)
    private var walls = [SCNNode]()
    
    /// константа для высчитывания размера рамки
    private let wallSizeConstants = SCNVector3(0.125, 0.1, 0.25)
    /// константа для расстояния между ячейками
    private let cellSpaceConstant = SCNVector3()
    
    /// задержка, перед закреплением детали
    /// чтобы пользователь мог двигать ее в последний момент
    private var isDelaying = false
    
    init() {
        self.node = SCNNode()
        
        let firstPartX: Float = Float(self.frameBottomVolume.x) + Float(self.spaceConstant.x) * 10.0
        let secondPartX: Float = Float(self.cellOffset.x) * 0.75
        
        let firstPartZ: Float = Float(self.frameBottomVolume.x) * 2.0 + Float(self.spaceConstant.y) * 20.0
        let secondPartZ: Float = Float(self.cellOffset.y) * Float(0.75)
        
        let frameSize = SCNVector3(x: firstPartX + secondPartX,
                                   y: self.frameBottomVolume.y,
                                   z: firstPartZ + secondPartZ)
        
        
        let frameBottomGeometry = SCNBox(width: Double(frameSize.x),
                                         height: Double(frameSize.y),
                                         length: Double(frameSize.z),
                                         chamferRadius: 0.0
                                        )
        
        let frameBottomMaterial = SCNMaterial()
        frameBottomMaterial.diffuse.contents = #colorLiteral(red: 0.4272378087, green: 0, blue: 1, alpha: 1)
        frameBottomGeometry.materials = [frameBottomMaterial]
        
        self.node.geometry = frameBottomGeometry
        
        let oneTenthOfWidth = self.frameBottomVolume.x/10.0
        // вычисление позиции определенной ячейки
        // i - вертикаль, j - горизонталь
        for i in 0...19 {
            var rowOfCells = [Cell3D]()
            for j in 0...9 {
                // сначала прибавляем cellOffset (чтобы рамка для ячеек не пересекалась с ячейками)
                // также добавляем небольшое расстояние(spaceConstant) между самими ячейками для лучшего вида
                // в конце отнимаем половину соотв. размера frameNode из за ее anchorPoint
                
                let firstPart: Float = self.cellOffset.x - oneTenthOfWidth*0.5 - oneTenthOfWidth * Float(j)
                let x = firstPart - self.spaceConstant.x * Float(j) + frameBottomVolume.x/1.8
                
                let cellPosition = SCNVector3(x: x,
                                              y: frameSize.y,
                                              z: self.cellOffset.y - oneTenthOfWidth*0.5 - oneTenthOfWidth * Float(i) - self.spaceConstant.y * Float(i) + frameBottomVolume.z/1.7
                                                )
                
                let cell = Cell3D(frameVolume: self.frameBottomVolume, position: cellPosition)

                self.node.addChildNode(cell.node)
                rowOfCells.append(cell)
            }
            self.cells.append(rowOfCells)
        }
        
    }
    
    func addFirstThreeTetrominos() {
        guard let currentTetromino = self.randomTetromino() else {
            return
        }
        
        self.addTetrominoInCells(tetromino: currentTetromino)
        
        guard let firstNextTetromino = self.randomTetromino(),
              let secondNextTetromino = self.randomTetromino(),
              let thirdNextTetromino = self.randomTetromino() else {
            return
        }
        
        self.nextTetrominos.append(firstNextTetromino)
        self.nextTetrominos.append(secondNextTetromino)
        self.nextTetrominos.append(thirdNextTetromino)
        
        // настраиваем tetrominos для их отображения в меню следующих фигур
        // константа размера, с помощью которой будем считать размер
        
    }
    func update(_ currentTime: TimeInterval, in arGameViewController: ARGameViewController) {
        for shape in shapes {
            if abs(shape.lastTime - currentTime) >= self.tetrominoSpeed {
                shape.lastTime = currentTime
                shape.moveDown(cells: self.cells)
                self.updateCells()
                self.checkFullRows(arGameViewController: arGameViewController)
                
                if !self.isDelaying {
                    self.f(arGameViewController: arGameViewController)
                }
            }
        }
    }
    func f(arGameViewController: ARGameViewController) {
        self.isDelaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + self.tetrominoSpeed*2.5) {
            
            if self.checkIfShouldLockCells() {
                self.addTetrominoInCells(tetromino: self.nextTetrominos.removeFirst())
                
                if let tetromino = self.randomTetromino() {
                    self.nextTetrominos.append(tetromino)
                    
                    arGameViewController.changeTetrominoInNextView(type: tetromino.type)
                }
            }
            self.isDelaying = false
        }
    }
    func updateCells(shouldComputeProjection: Bool = true) {
        for shape in shapes {
            if shape.isLocked {
                continue
            }
            
            var shapeProjectionPositions = [Position]()
            if shouldComputeProjection {
                shapeProjectionPositions = shape.computeProjectionPositions(cells: self.cells)
            }
            for (y,row) in self.cells.enumerated() {
                for (x,cell) in row.enumerated() {
                    if cell.isLocked {
                        continue
                    }
                    
                    // считаем позицию фигуры
                    for position in shape.positions {
                        if position.x == x && position.y == y {
                            cell.hasCurrentTetrominoIn = true
//                            cell.fillTexture = Tetromino.skins[UserCustomization.currentTetrominoSkinIndex][shape.type.rawValue]
                            cell.fillColor = .red
                            break
                        } else {
                            cell.hasCurrentTetrominoIn = false
                        }
                    }
                    
                    if shouldComputeProjection {
                        shape.projectionPositions = shapeProjectionPositions
                        // считаем проекцию фигуры
                        for position in shapeProjectionPositions {
                            if position.x == x && position.y == y {
                                cell.hasCurrentTetrominoProjectionIn = true
                                break
                            } else {
                                if !cell.hasCurrentTetrominoIn {
                                    cell.hasCurrentTetrominoProjectionIn = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func moveShapeToBottom(arGameViewController: ARGameViewController) {
        self.updateCells(shouldComputeProjection: false)
        self.checkFullRows(arGameViewController: arGameViewController)
        if self.checkIfShouldLockCells() {
            self.addTetrominoInCells(tetromino: self.nextTetrominos.removeFirst())
            
            if let tetromino = self.randomTetromino() {
                self.nextTetrominos.append(tetromino)
                
                arGameViewController.changeTetrominoInNextView(type: tetromino.type)
            }
        }
    }
    private func randomTetromino() -> Tetromino? {
        var randomIndex = Int.random(in: 0...6)
//        randomIndex = 0
        let tetrominoType = TetrominoType(rawValue: randomIndex)
        
        switch tetrominoType {
        case .i:
            return I_Shape()
        case .s:
            return S_Shape()
        case .z:
            return Z_Shape()
        case .l:
            return L_Shape()
        case .j:
            return J_Shape()
        case .o:
            return O_Shape()
        case .t:
            return T_Shape()
        case nil:
            return nil
        }
    }
    func checkIfShouldLockCells() -> Bool {
        for (i, shape) in shapes.enumerated() {
            if shape.isLocked {
                continue
            }
            for position in shape.positions {
                if position.y == 0 {
                    shape.isLocked = true
                    lockCells(shapeIndex: i)
                    return true
                }
                if cells[position.y-1][position.x].isLocked {
                    shape.isLocked = true
                    lockCells(shapeIndex: i)
                    return true
                }
            }
        }
        return false
    }
    func lockCells(shapeIndex: Int) {
        let shape = self.shapes[shapeIndex]
        for position in shape.positions {
            if position.y < 0 {
                while position.y < 0 {
                    shape.moveUp()
                }
            }
        }
        for position in shape.positions {
            self.cells[position.y][position.x].isLocked = true
        }
    }
    func checkFullRows(arGameViewController: ARGameViewController) {
        var rowToRemove = [Int]()
        for (j, row) in self.cells.enumerated() {
            var isFull = true
            for cell in row {
                if !cell.isLocked {
                    isFull = false
                    break
                }
            }
            
            if isFull {
                rowToRemove.append(j)
            }
        }
        
        for row in rowToRemove {
            arGameViewController.destroyedLines += 1
            if arGameViewController.destroyedLines % 10 == 0 {
                arGameViewController.currentLevel += 1
                self.tetrominoSpeed = 1/Double(arGameViewController.currentLevel)
            }
            arGameViewController.currentScore += 100 * arGameViewController.currentLevel
            self.removeRow(j: row)
            
            self.moveDownRow(j: row+1)
        }
    }
    /// удаляет ряд по индексу j
    ///
    ///  - Parameters:
    ///    - j: номер ряда, который нужно удалить
    func removeRow(j: Int) {
        for (j_, row) in self.cells.enumerated() {
            if j_ != j {
                continue
            }
            
            for cell in row {
                cell.isLocked = false
                cell.hasCurrentTetrominoIn = false
            }
        }
    }
    /// перемещает все закрепленные ряды выше r на один ниже
    private func moveDownRow(j: Int) {
        guard j <= 19 else {
            return
        }
        var rowNumber = j
        while rowNumber < 20 {
            let row = self.cells[rowNumber]
            for (i,cell) in row.enumerated() {
                if cell.isLocked {
                    cell.isLocked = false
//                    let texture = cell.fillTexture
                    cell.hasCurrentTetrominoIn = false
                    
                    self.cells[rowNumber-1][i].isLocked = true
//                    self.cells[rowNumber-1][i].fillTexture = texture
                    self.cells[rowNumber-1][i].fillColor = .red
                }
            }
            rowNumber+=1
        }
    }
    func addTetrominoInCells(tetromino: Tetromino) {
        if !self.shapes.isEmpty {
            self.shapes.removeLast().positions = []
        }
        for position in tetromino.positions {
            self.cells[position.y][position.x].hasCurrentTetrominoIn = true
//            self.cells[position.y][position.x].fillTexture = Tetromino.skins[UserCustomization.currentTetrominoSkinIndex][tetromino
//                .type.rawValue]
            self.cells[position.y][position.x].fillColor = .red
        }
        self.shapes.append(tetromino)
    }
    func clearCells() {
        self.shapes = []
        self.nextTetrominos = []
        
        for row in self.cells {
            for cell in row {
                cell.isLocked = false
                cell.hasCurrentTetrominoIn = false
//                cell.fillTexture = nil
                cell.hasCurrentTetrominoProjectionIn = false
                cell.fillColor = .clear
            }
        }
    }

    func addFrame(to parentNode: SCNNode, in position: SCNVector3) {
        self.node.position = position
        parentNode.addChildNode(self.node)
    }
}
