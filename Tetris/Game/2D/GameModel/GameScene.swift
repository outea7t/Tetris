//
//  GameScene.swift
//  Tetris
//
//  Created by Out East on 18.10.2023.
//

import Foundation
import SwiftUI
import SpriteKit

fileprivate class TouchTimeInformation {
    /// задержка после мгновенного спуска фигуры
    static var touchTimeDelay: TimeInterval = 0.3
    /// время последнего мгновенного спуска фигуры
    static var lastMoveToBottomTime: TimeInterval = 0.0
}

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
    
    var gainedMoney = MoneyGainingLogic()
    
    var isGamePaused = false
    
    private var startTouchYPosition = CGFloat()
    private var startTouchXPosition = CGFloat()
    
    var cellFrameNode: Frame2D?
    var nextShapeView_: NextShapeView?
    
    private var isDelaying = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundColor = #colorLiteral(red: 0.006714879069, green: 0.005665164441, blue: 0.1188637391, alpha: 1)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.friction = 0.0
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.linearDamping = 0.0
        
        Tetromino.setSkins()
        
        self.cellFrameNode = Frame2D(gameScene: self)
        self.cellFrameNode?.addFirstThreeTetrominos()
        
        guard let frameNode = self.cellFrameNode else {
            return
        }
        
        self.nextShapeView_ = NextShapeView(frame: frameNode, gameScene: self)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        guard !self.isGamePaused else {
            return
        }
        self.cellFrameNode?.update(currentTime, in: self)
    }
    
    func pauseGame() {
        self.isGamePaused = true
    }
    func unpauseGame() {
        self.isGamePaused = false
    }
    func clearCells() {
        self.cellFrameNode?.clearCells()
    }
    
    func onTapGesture() {
        guard !self.isGamePaused else {
            return
        }
        guard let cellFrameNode = self.cellFrameNode else {
            return
        }
        for shape in cellFrameNode.shapes {
            shape.rotate(cells: cellFrameNode.cells)
        }
        cellFrameNode.updateCells()
    }
    
    func moveShapeVertical(touch: DragGesture.Value) -> Bool {
        guard abs(touch.location.y - self.startTouchYPosition) >= 25 else {
            return false
        }
        guard let cellFrameNode = self.cellFrameNode else {
            return false
        }
        
        self.startTouchYPosition = touch.startLocation.y
        for shape in cellFrameNode.shapes {
            if shape.isLocked {
                continue
            }
            guard abs(touch.velocity.height) < 1000 else {
                guard touch.time.timeIntervalSince1970 - TouchTimeInformation.lastMoveToBottomTime >= TouchTimeInformation.touchTimeDelay else {
                    return true
                }
                TouchTimeInformation.lastMoveToBottomTime = touch.time.timeIntervalSince1970
                self.gainedMoney.numberOfPullDowns += 1
                shape.moveToBottom(gameScene: self)
                self.startTouchYPosition = 0
                return true
            }
            if touch.location.y - self.startTouchYPosition > 0 {
                shape.moveDown(cells: cellFrameNode.cells)
                cellFrameNode.updateCells()
            }
        }
        self.startTouchYPosition = touch.location.y
        return true
    }
    func moveShapeHorizontal(touch: DragGesture.Value) {
        guard abs(touch.location.x - self.startTouchXPosition) >= 25 else {
            return
        }
        guard let cellFrameNode = self.cellFrameNode else {
            return
        }
        
        self.startTouchXPosition = touch.startLocation.x
        for shape in cellFrameNode.shapes {
            if shape.isLocked {
                continue
            }
            if self.startTouchXPosition - touch.location.x > 0 {
                shape.moveToLeft(cells: cellFrameNode.cells)
                cellFrameNode.updateCells()
            } else if self.startTouchXPosition - touch.location.x < 0  {
                shape.moveToRight(cells: cellFrameNode.cells)
                cellFrameNode.updateCells()
            }
        }
        self.startTouchXPosition = touch.location.x
    }
    
    func changeTetrominoInNextView(type: TetrominoType) {
        self.nextShapeView_?.changeTetrominoInNextView(type: type)
    }
    
    /// перезапуск игры и очистка всей информации о прошлом игровом сеансе
    func resetGame() {
        self.isGamePaused = false
        self.destroyedLines = 0
        self.currentScore = 0
        self.currentLevel = 0
        self.cellFrameNode?.clearCells()
        self.cellFrameNode?.addFirstThreeTetrominos()
        
        guard let cellFrameNode = self.cellFrameNode else {
            return
        }
        
        self.nextShapeView_?.addNextTetrominos(frame: cellFrameNode)
        self.nextShapeView_?.clearAllTetrominos()
    }
    // возможен сценарий, что пользователь захочет "переиграть"
    // поэтому очищаем информацию о прошлом игровом сеансе
    func setLose() {
        self.gainedMoney.numberOfDestroyedLines = self.destroyedLines
        if let suiViewDelegate = self.suiViewDelegate as? GameView {
            self.isGamePaused = true
            suiViewDelegate.showLoseView()
        }
    }
}
