//
//  Tetromino.swift
//  Tetris
//
//  Created by Out East on 22.10.2023.
//

import Foundation
import SpriteKit

enum TetrominoType: Int {
    case i // 0
    case s // 1
    case z // 2
    case l // 3
    case j // 4
    case o // 5
    case t // 6
}

enum TetrominoRotationType: Int {
    case center =     0
    case left =       1
    case upsideDown = 2
    case right =      3
}
class Position {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    init() {
        self.x = 0
        self.y = 0
    }
}

struct TetrominoSkin {
    var skins = Array(repeating: SKTexture(), count: 7)
    
    subscript(index: Int) -> SKTexture {
        get {
            return skins[index]
        } set {
            skins[index] = newValue
        }
    }
}
/// базовый класс для фигур
class Tetromino {
    public static var skins = [TetrominoSkin]()
    
    var type: TetrominoType = .i
    var positions = [Position]()
    var currentRotation = TetrominoRotationType.center
    var isLocked = false
    var lastTime: TimeInterval = 0
    
    var projectionPositions = [Position]()
    func moveToBottom(cells: [[Cell]]) {
        guard !self.isLocked else {
            return
        }
        var destinationPositions = [Position]()
        
        let bottomPositions = self.projectionPositions
        for projectionPosition in bottomPositions {
            destinationPositions.append(Position(x: projectionPosition.x, y: projectionPosition.y))
        }
        
        self.positions = destinationPositions
        
        
        GameScene.shared.updateCells(shouldComputeProjection: false)
        GameScene.shared.checkFullRows()
        if GameScene.shared.checkIfShouldLockCells() {
            GameScene.shared.addTetrominoInCells(tetromino: GameScene.shared.nextTetrominos.removeFirst())
            
            if let tetromino = GameScene.shared.randomTetromino() {
                GameScene.shared.nextTetrominos.append(tetromino)
                
                GameScene.shared.changeTetrominoInNextView(type: tetromino.type)
            }
        }
//        self.isLocked = true
    }
    /// двигает фигуру вниз
    func moveDown(cells: [[Cell]]) {
        guard !self.isLocked else {
            return
        }
        for position in positions {
            if position.y - 1 < 0 || cells[position.y-1][position.x].isLocked {
                return
            }
        }
        
        for position in positions {
            position.y -= 1
        }
    }
    
    func moveUp() {
//        guard !self.isLocked else {
//            return
//        }
        for position in positions {
            position.y += 1
        }
    }
    /// расчитывает текущую позицию проекции фигуры
    ///
    /// - Parameters:
    ///     - cells: рамка с ячейками, хранящая информацию о занятых/свободных ячейках
    func computeProjectionPositions(cells: [[Cell]]) -> [Position] {
        var projectionPositions = [Position]()
        
        for position in self.positions {
            let (x,y) = (position.x, position.y)
            projectionPositions.append(Position(x: x, y: y))
        }
        
        var currentXPositions = [Int]()
        var minYPosition = self.positions[0].y
        for position in self.positions {
            currentXPositions.append(position.x)
            minYPosition = min(minYPosition, position.y)
        }
        
       
        while minYPosition > 0 {
            for position in projectionPositions {
                position.y -= 1
                minYPosition = min(minYPosition, position.y)
            }
            
            for position in projectionPositions {
                guard position.y >= 0 && position.x >= 0 && position.x <= 9 else {
                    return projectionPositions
                }
                var y = position.y-1 > 0 ? position.y-1 : 0
                if cells[y][position.x].isLocked {
                    return projectionPositions
                }
            }
        }
        return projectionPositions
    }

    /// проверяет, может ли фигура сделать поворот
    /// - Parameters:
    ///     - cells: ячейки с информацией о закрепленных фигурах
    ///     - positions: позиции фигуры после ее поворота
    func checkIfCanRotate(cells: [[Cell]], positions: [Position]) -> Bool {
        for position in positions {
            guard position.y >= 0 && position.y <= 19 && position.x <= 9 && position.x >= 0 else {
                return true
            }
            if cells[position.y][position.x].isLocked {
                return false
            }
        }
        return true
    }
    
    /// двигает фигуру влево
    /// * предотвращает выход фигуры за пределы экрана
    final func moveToLeft(cells: [[Cell]]) {
        guard !self.isLocked else {
            return
        }
        for position in positions {
            if position.x - 1 < 0 {
                return
            }
            if cells[position.y][position.x-1].isLocked  {
                return
            }
        }
        for position in positions {
            position.x-=1
        }
    }
    
    /// двигает фигуру вправо
    /// * предотвращает выход фигуры за пределы экрана
    final func moveToRight(cells: [[Cell]]) {
        guard !self.isLocked else {
            return
        }
        for position in positions {
            if position.x + 1 > 9 {
                return
            }
            if cells[position.y][position.x+1].isLocked  {
                return
            }
        }
        for position in positions {
            position.x += 1
        }
    }
    
    /// функция, которая вызывается при повороте фигуры
    /// * учитывает, что позиция фигуры может выйти за пределы ячеек
    final func rotate(cells: [[Cell]]) {
        guard let currentRotation = TetrominoRotationType(rawValue: ((self.currentRotation.rawValue + 1)%4)) else {
            return
        }
        
        self.currentRotation = currentRotation
        
        
        switch self.currentRotation {
        case .left:
            self.rotateToLeft(cells: cells)
        case .upsideDown:
            self.rotateToUpsideDown(cells: cells)
        case .right:
            self.rotateToRight(cells: cells)
        case .center:
            self.rotateToCenter(cells: cells)
        }
        
    }
    
    /// смотрим, если какая-то часть фигуры при повороте выходит за пределы рамки, то корректируем ее позицию
    func correctPosition(tempPositions: [Position]) {
        // если позиция выходит за границы рамки, изменяем ее
        for position in tempPositions {
            while position.x > 9 {
                tempPositions[0].x -= 1
                tempPositions[1].x -= 1
                tempPositions[2].x -= 1
                tempPositions[3].x -= 1
                break
            }
            while position.x < 0 {
                tempPositions[0].x += 1
                tempPositions[1].x += 1
                tempPositions[2].x += 1
                tempPositions[3].x += 1
            }
            
            while position.y < 0 {
                tempPositions[0].y += 1
                tempPositions[1].y += 1
                tempPositions[2].y += 1
                tempPositions[3].y += 1
            }
        }
    }
    
    func rotateToLeft(cells: [[Cell]]) {
        
    }
    func rotateToUpsideDown(cells: [[Cell]]) {
        
    }
    func rotateToRight(cells: [[Cell]]) {
        
    }
    func rotateToCenter(cells: [[Cell]]) {
        
    }
    
    static func setSkins(isSkinsSet: inout Bool) {
        let names = ["I", "S", "Z", "L", "J", "O", "T"]

        for i in 0..<UserCustomization.maxTetrominoSkinIndex {
            var skinSet = [SKTexture]()
            for j in 0..<7 {
                var str = "\(names[j])-\(i+1)"
                if let image = UIImage(named: str) {
                    let texture = SKTexture(image: image)
                    skinSet.append(texture)
                }
            }
            self.skins.append(TetrominoSkin(skins: skinSet))
        }
        
        isSkinsSet = true
    }
}
