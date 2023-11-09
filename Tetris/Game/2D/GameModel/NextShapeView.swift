//
//  NextShapeView.swift
//  Tetris
//
//  Created by Out East on 09.11.2023.
//

import Foundation
import SpriteKit

// TODO: Инкапсулировать логику меню со следующими фигурами
class NextShapeView {
    /// node, которая показывает следующие фигуры
    var nextShapeNode: SKShapeNode?
    /// текстуры всех фигур, которые есть в игре
    var tetrominos = [SKSpriteNode]()
    /// фигуры, находящиеся в меню следующих фигур
    var tetrominosInNextShapesNode = [SKSpriteNode]()
    /// позиции следующих фигур в меню след. фигур
    var nextFiguresPositions = [CGPoint]()
    /// константа для размера ячейки
    private let constantForCellSize: CGFloat = 0.06581197
    
    init(frame: Frame, gameScene: GameScene) {
        let scaleConstant = self.constantForCellSize / 3 * gameScene.frame.width

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
        let nextShapeViewSize = CGSize(width: nextShapeViewSizeConstant.width * gameScene.frame.width,
                                       height: nextShapeViewSizeConstant.height * gameScene.frame.height)
        self.nextShapeNode = SKShapeNode(rectOf: nextShapeViewSize,
                                         cornerRadius: 7)
        
        self.nextShapeNode?.lineWidth = 4
        self.nextShapeNode?.strokeColor = #colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 1, alpha: 1)
        self.nextShapeNode?.fillColor = #colorLiteral(red: 0.09019607843, green: 0.1058823529, blue: 0.2509803922, alpha: 1)
        
        // считаем позицию меню так, чтобы оно было выравнено по верху рамки с ячейками
        let nextShapeViewPosition = CGPoint(x: frame.frameNode.position.x + frame.frameNode.frame.width/2.0 + nextShapeViewSize.width/2.0 + 7.5,
                                            y: frame.frameNode.position.y + frame.frameNode.frame.height/2.0 - nextShapeViewSize.height/2.0 - 3)
        
        self.nextShapeNode?.position = nextShapeViewPosition
        
        guard let nextShapeNode = self.nextShapeNode else {
            return
        }
        
        gameScene.addChild(nextShapeNode)
        
        self.nextFiguresPositions.append(CGPoint(x: 0, y: 0.33*nextShapeViewSize.height))
        self.nextFiguresPositions.append(CGPoint())
        self.nextFiguresPositions.append(CGPoint(x: 0, y: -0.33*nextShapeViewSize.height))

        var i: Int = 0
        for tetromino in frame.nextTetrominos {
            if let tetromino = self.tetrominos[tetromino.type.rawValue].copy() as? SKSpriteNode {
                let position = self.nextFiguresPositions[i]
                tetromino.position = position
                self.nextShapeNode?.addChild(tetromino)
                self.tetrominosInNextShapesNode.append(tetromino)
                i+=1
            }
        }
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
        self.nextShapeNode?.addChild(tetromino)
        self.tetrominosInNextShapesNode.append(tetromino)
    }
}
