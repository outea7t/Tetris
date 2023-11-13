//
//  Frame.swift
//  Tetris
//
//  Created by Out East on 09.11.2023.
//

import Foundation
import SpriteKit

// TODO: Перестать хранить все фигуры, которые когда либо падали, достаточно хранить информацию только о предыдущей
class Frame {
    // константы для высчитывания размеров элементов рамки с ячейками
    private let constantForFrameWidth: CGFloat = 0.608547008547009
    private let constantForCellSize: CGFloat = 0.06581197
    private let spaceConstant = CGPoint(x: 3.0, y: 3.0)
    private let cellOffset = CGPoint(x: 7.0, y: 7.0)
    
    /// скорость падения тетромино
    private var tetrominoSpeed: Double = 1/1
    var cells = [[Cell]]()
    
    var frameNode: SKShapeNode
    
    /// фигуры, которые выпадали игроку
    var shapes = [Tetromino]()
    /// следующие фигуры
    var nextTetrominos = [Tetromino]()
    
    private var isDelaying = false
    
    init(gameScene: GameScene) {
        
        let frameWidth = self.constantForFrameWidth * gameScene.frame.width
        let frameSize = CGSize(width: frameWidth + self.spaceConstant.x * 10 + self.cellOffset.x*0.75,
                               height: frameWidth * 2 + self.spaceConstant.y * 20 + self.cellOffset.y*0.75)

        self.frameNode = SKShapeNode(rectOf: frameSize, cornerRadius: 10)
        
        frameNode.strokeColor = #colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 1, alpha: 1)
        frameNode.lineWidth = 4.0
        frameNode.position = CGPoint(x: gameScene.frame.midX - 30,
                                     y: gameScene.frame.midY - 40)
        
        gameScene.addChild(frameNode)
        
        let cellWidth = self.constantForFrameWidth * gameScene.frame.width
        let cellFrameSize = CGSize(width: cellWidth,
                               height: cellWidth*2)
        
        let oneTenthOfWidth = cellFrameSize.width/10
        
        // вычисление позиции определенной ячейки
        // i - вертикаль, j - горизонталь
        for i in 0...19 {
            var rowOfCells = [Cell]()
            for j in 0...9 {
                // сначала прибавляем cellOffset (чтобы рамка для ячеек не пересекалась с ячейками)
                // также добавляем небольшое расстояние(spaceConstant) между самими ячейками для лучшего вида
                // в конце отнимаем половину соотв. размера frameNode из за ее anchorPoint
                let cellPosition = CGPoint(x: self.cellOffset.x + oneTenthOfWidth*0.5 + oneTenthOfWidth * CGFloat(j) + self.spaceConstant.x * CGFloat(j) - frameNode.frame.width/2.0,
                                           y: self.cellOffset.y + oneTenthOfWidth*0.5 + oneTenthOfWidth * CGFloat(i) + self.spaceConstant.y * CGFloat(i) - frameNode.frame.height/2.0)
                
                let cell = Cell(frameSize: cellFrameSize, position: cellPosition)
                
                frameNode.addChild(cell.node)
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
    func update(_ currentTime: TimeInterval, in gameScene: GameScene) {
        for shape in shapes {
            if abs(shape.lastTime - currentTime) >= self.tetrominoSpeed {
                shape.lastTime = currentTime
                shape.moveDown(cells: self.cells)
                self.updateCells()
                self.checkFullRows(gameScene: gameScene)
                
                if !self.isDelaying {
                    self.f(gameScene: gameScene)
                }
            }
        }
    }
    func f(gameScene: GameScene) {
        self.isDelaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + self.tetrominoSpeed*2.5) {
            
            if self.checkIfShouldLockCells() {
                self.addTetrominoInCells(tetromino: self.nextTetrominos.removeFirst())
                
                if let tetromino = self.randomTetromino() {
                    self.nextTetrominos.append(tetromino)
                    
                    gameScene.changeTetrominoInNextView(type: tetromino.type)
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
                            cell.fillTexture = Tetromino.skins[UserCustomization.currentTetrominoSkinIndex][shape.type.rawValue]
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
    
    func moveShapeToBottom(gameScene: GameScene) {
        self.updateCells(shouldComputeProjection: false)
        self.checkFullRows(gameScene: gameScene)
        if self.checkIfShouldLockCells() {
            self.addTetrominoInCells(tetromino: self.nextTetrominos.removeFirst())
            
            if let tetromino = self.randomTetromino() {
                self.nextTetrominos.append(tetromino)
                
                GameScene.shared.changeTetrominoInNextView(type: tetromino.type)
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
    
    func checkFullRows(gameScene: GameScene) {
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
            gameScene.destroyedLines += 1
            if gameScene.destroyedLines % 10 == 0 {
                gameScene.currentLevel += 1
                self.tetrominoSpeed = 1/Double(gameScene.currentLevel)
            }
            gameScene.currentScore += 100 * gameScene.currentLevel
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
                    let texture = cell.fillTexture
                    cell.hasCurrentTetrominoIn = false
                    
                    self.cells[rowNumber-1][i].isLocked = true
                    self.cells[rowNumber-1][i].fillTexture = texture
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
            self.cells[position.y][position.x].fillTexture = Tetromino.skins[UserCustomization.currentTetrominoSkinIndex][tetromino
                .type.rawValue]
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
                cell.fillTexture = nil
                cell.hasCurrentTetrominoProjectionIn = false
                cell.fillColor = .clear
            }
        }
    }
}
