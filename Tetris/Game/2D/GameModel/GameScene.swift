//
//  GameScene.swift
//  Tetris
//
//  Created by Out East on 18.10.2023.
//

import Foundation
import SwiftUI
import SpriteKit


class GameScene: SKScene {
    static var shared = GameScene()
    
    var suiViewDelegate: (any View)?
    
    /// количество уничтоженных линий
    var destroyedLines: Int = 0 {
        willSet {
            if let suiViewDelegate = self.suiViewDelegate as? GameView {
                suiViewDelegate.destroyedLines = newValue
            }
        }
    }
    /// текущий счет игрока
    var currentScore: Int = 0 {
        willSet {
            if let suiViewDelegate = self.suiViewDelegate as? GameView {
                suiViewDelegate.currentScore = newValue
            }
        }
    }
    /// текущий уровень игрока
    /// от него будет зависеть скорость падения деталей
    var currentLevel: Int = 1 {
        willSet {
            if let suiViewDelegate = self.suiViewDelegate as? GameView {
                suiViewDelegate.currentLevel = newValue
            }
        }
    }
    
    var isGamePaused = false
    /// константа для вычисления размера ячеек
    private let constantForCellSize: CGFloat = 0.06581197
    /// константы для вычисления размера рамки
    private let constantForFrameWidth: CGFloat = 0.608547008547009
    private let spaceConstant = CGPoint(x: 3.0, y: 3.0)
    private let cellOffset = CGPoint(x: 7.0, y: 7.0)
    private var cellFrameNode: SKShapeNode?
    
    /// скорость падения тетромино
    private var tetrominoSpeed: Double = 1/1
    
    var cells = [[Cell]]()
    /// фигуры, которые выпадали игроку
    var shapes = [Tetromino]()
    /// следующие фигуры
    var nextTetrominos = [Tetromino]()
    /// node, которая показывает следующие фигуры
    var nextShapeView: SKShapeNode?
    /// текстуры всех фигур, которые есть в игре
    var tetrominos = [SKSpriteNode]()
    /// фигуры, находящиеся в меню следующих фигур
    var tetrominosInNextShapesNode = [SKSpriteNode]()
    /// позиции следующих фигур в меню след. фигур
    var nextFiguresPositions = [CGPoint]()
    
    private var isSkinsSet = false
    private var isDelaying = false
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
        Tetromino.setSkins(isSkinsSet: &isSkinsSet)
        self.backgroundColor = #colorLiteral(red: 0.006714879069, green: 0.005665164441, blue: 0.1188637391, alpha: 1)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.friction = 0.0
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.linearDamping = 0.0
        
        self.cellFrameNode = self.addFrameForCells()
        
        guard let frameNode = self.cellFrameNode else {
            return
        }
        
        self.addCells(frameNode: frameNode)
        
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
        
        let scaleConstant = self.constantForCellSize / 3 * 390

        let imagesNames = ["I", "S","Z", "L", "J", "O", "T"]
        let tetrominoSizes = [
            "I": CGSize(width: scaleConstant, height: scaleConstant*4),
            "J": CGSize(width: scaleConstant*2, height: scaleConstant*3),
            "L": CGSize(width: scaleConstant*2, height: scaleConstant*3),
            "O": CGSize(width: scaleConstant*2, height: scaleConstant*2),
            "S": CGSize(width: scaleConstant*2, height: scaleConstant*3),
            "T": CGSize(width: scaleConstant*3, height: scaleConstant*2),
            "Z": CGSize(width: scaleConstant*2, height: scaleConstant*3)
        ]
        for imageName in imagesNames {
            if let image = UIImage(named: imageName), let size = tetrominoSizes[imageName] {
                let texture = SKTexture(image: image)
                let tetromino = SKSpriteNode(texture: texture, size: size)
                
                self.tetrominos.append(tetromino)
            }
        }
        
        let x: CGFloat = 70/390
        let y: CGFloat = 130/844
        let nextShapeViewSizeConstant = CGSize(width: x, height: y)
        let nextShapeViewSize = CGSize(width: nextShapeViewSizeConstant.width * self.frame.width,
                                       height: nextShapeViewSizeConstant.height * self.frame.height)
        self.nextShapeView = SKShapeNode(rectOf: nextShapeViewSize,
                                         cornerRadius: 7)
        
        self.nextShapeView?.lineWidth = 4
        self.nextShapeView?.strokeColor = #colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 1, alpha: 1)
        self.nextShapeView?.fillColor = #colorLiteral(red: 0.09019607843, green: 0.1058823529, blue: 0.2509803922, alpha: 1)
        
        // считаем позицию меню так, чтобы оно было выравнено по верху рамки с ячейками
        let nextShapeViewPosition = CGPoint(x: frameNode.position.x + frameNode.frame.width/2.0 + nextShapeViewSize.width/2.0 + 7.5,
                                            y: frameNode.position.y + frameNode.frame.height/2.0 - nextShapeViewSize.height/2.0 - 3)
        
        self.nextShapeView?.position = nextShapeViewPosition
        
        guard let nextShapeView = self.nextShapeView else {
            return
        }
        
        self.addChild(nextShapeView)
        
        self.nextFiguresPositions.append(CGPoint(x: 0, y: 0.33*nextShapeViewSize.height))
        self.nextFiguresPositions.append(CGPoint())
        self.nextFiguresPositions.append(CGPoint(x: 0, y: -0.33*nextShapeViewSize.height))

        var i: Int = 0
        for tetromino in nextTetrominos {
            if let tetromino = self.tetrominos[tetromino.type.rawValue].copy() as? SKSpriteNode {
                let position = self.nextFiguresPositions[i]
                tetromino.position = position
                self.nextShapeView?.addChild(tetromino)
                self.tetrominosInNextShapesNode.append(tetromino)
                i+=1
            }
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        guard !self.isGamePaused else {
            return
        }
        for shape in shapes {
            if abs(shape.lastTime - currentTime) >= self.tetrominoSpeed {
                shape.lastTime = currentTime
                shape.moveDown(cells: self.cells)
                self.updateCells()
                self.checkFullRows()
                
                if !self.isDelaying {
                    self.f()
                }
            }
        }
    }
    func f() {
        self.isDelaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + self.tetrominoSpeed*2.5) {
            if self.checkIfShouldLockCells() {
                self.addTetrominoInCells(tetromino: self.nextTetrominos.removeFirst())
                
                if let tetromino = self.randomTetromino() {
                    self.nextTetrominos.append(tetromino)
                    
                    self.changeTetrominoInNextView(type: tetromino.type)
                }
            }
            self.isDelaying = false
        }
    }
    func pauseGame() {
        self.isGamePaused = true
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
    /// places frame for cells, and returns it's size
    func addFrameForCells() -> SKShapeNode {
        let width = self.constantForFrameWidth * self.frame.width
        let frameSize = CGSize(width: width + self.spaceConstant.x * 10 + self.cellOffset.x*0.75,
                               height: width * 2 + self.spaceConstant.y * 20 + self.cellOffset.y*0.75)

        let frameNode = SKShapeNode(rectOf: frameSize, cornerRadius: 10)
        
        frameNode.strokeColor = #colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 1, alpha: 1)
        frameNode.lineWidth = 4.0
        frameNode.position = CGPoint(x: self.frame.midX - 30,
                                     y: self.frame.midY - 40)
        
        self.addChild(frameNode)
        
        return frameNode
    }
    
    /// places 10*20 cells in frameNode
    func addCells(frameNode: SKShapeNode) {
        let width = self.constantForFrameWidth * self.frame.width
        let frameSize = CGSize(width: width,
                               height: width*2)
        let oneTenthOfWidth = frameSize.width/10
        
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
                
                let cell = Cell(frameSize: frameSize, position: cellPosition)
                
                frameNode.addChild(cell.node)
                rowOfCells.append(cell)
            }
            self.cells.append(rowOfCells)
        }
    }
    
    func randomTetromino() -> Tetromino? {
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
    func checkFullRows() {
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
            self.destroyedLines += 1
            if self.destroyedLines % 10 == 0 {
                self.currentLevel += 1
                self.tetrominoSpeed = 1/Double(self.currentLevel)
            }
            self.currentScore += 100 * self.currentLevel
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
    func moveDownRow(j: Int) {
        guard j <= 19 else {
            return
        }
        var rowNumber = j
        while rowNumber < 20 {
            let row = self.cells[rowNumber]
            for (i,cell) in row.enumerated() {
                if cell.isLocked {
                    cell.isLocked = false
                    var texture = cell.fillTexture
                    cell.hasCurrentTetrominoIn = false
                    
                    self.cells[rowNumber-1][i].isLocked = true
                    self.cells[rowNumber-1][i].fillTexture = texture
                }
            }
            rowNumber+=1
        }
    }
    func addTetrominoInCells(tetromino: Tetromino) {
        for position in tetromino.positions {
            self.cells[position.y][position.x].hasCurrentTetrominoIn = true
            self.cells[position.y][position.x].fillTexture = Tetromino.skins[UserCustomization.currentTetrominoSkinIndex][tetromino
                .type.rawValue]
        }
        self.shapes.append(tetromino)
    }
    
    func changeTetrominoInNextView(type: TetrominoType) {
        guard let tetromino = self.tetrominos[type.rawValue].copy() as? SKSpriteNode else {
            return
        }
        
        self.tetrominosInNextShapesNode[0].removeFromParent()
        self.tetrominosInNextShapesNode[1].position = self.nextFiguresPositions[0]
        self.tetrominosInNextShapesNode[2].position = self.nextFiguresPositions[1]
        self.tetrominosInNextShapesNode.removeFirst()
        
        tetromino.position = self.nextFiguresPositions[2]
        self.nextShapeView?.addChild(tetromino)
        self.tetrominosInNextShapesNode.append(tetromino)
    }
}
