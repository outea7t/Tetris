//
//  BackgroundAnimation.swift
//  Tetris
//
//  Created by Out East on 22.10.2023.
//

import Foundation
import SpriteKit

class BackgroundAnimation: SKScene {
    
    let time: TimeInterval = 1
    var lastTimeSpawned: TimeInterval = 0
    var tetrominos = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // константа размера, с помощью которой будем считать размер фигур
        
        self.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0, blue: 0.09019607843, alpha: 1)
        let scaleConstant = self.frame.width/10
        
        let imagesNames = ["I", "J", "L", "O", "S", "T", "Z"]
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
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if abs(self.lastTimeSpawned - currentTime) >= self.time {
            self.lastTimeSpawned = currentTime
            self.addRandomTetromino()
        }
    }
    /// добавляет случайное тетромино на случайную позизию и добавляет к нему действие "полета вниз"
    /// по оканчании действия удаляет тетромино
    func addRandomTetromino() {
        let oneTenthOfWidth = self.frame.width/10
        let randomIndex = Int.random(in: 0..<self.tetrominos.count)
        let randomXPosition = CGFloat.random(in: (oneTenthOfWidth/2.0)...(self.frame.width-oneTenthOfWidth/2.0))
        
        guard let tetromino = self.tetrominos[randomIndex].copy() as? SKSpriteNode else {
            return
        }
        
        tetromino.position = CGPoint(x: randomXPosition, y: self.frame.height + oneTenthOfWidth*2)
        
        let action = SKAction.sequence([
            .move(to: CGPoint(x: randomXPosition, y: -oneTenthOfWidth*2), duration: 5),
            .removeFromParent()
        ])
        
        self.addChild(tetromino)
        tetromino.run(action)
    }
}
