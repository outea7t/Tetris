//
//  Cell.swift
//  Tetris
//
//  Created by Out East on 18.10.2023.
//

import Foundation
import SpriteKit

class Cell {
    var frameSize: CGSize
    var calculatedCellSize: CGSize
    var node: SKShapeNode
    var textureNode: SKSpriteNode
    
    var hasCurrentTetrominoIn = false {
        willSet {
            if newValue {
//                self.fillColor = .white
            } else {
                self.fillColor = .clear
                self.fillTexture = nil
            }
        }
    }
    
    var hasCurrentTetrominoProjectionIn = false {
        willSet {
            if newValue {
                let image = UIImage(named: "Projection")!
                let texture = SKTexture(image: image)
                if self.fillTexture == nil {
                    self.fillTexture = texture
                }
            } else {
                self.fillColor = .clear
                self.fillTexture = nil
            }
        }
    }
    
    var isLocked = false
    
    var fillColor = UIColor.clear
    var fillTexture: SKTexture? = nil {
        willSet {
            self.node.fillColor = #colorLiteral(red: 0.007843137255, green: 0, blue: 0.09019607843, alpha: 1)
            self.textureNode.texture = newValue
        }
    }
    
    init(frameSize: CGSize, position: CGPoint) {
        self.frameSize = frameSize
        self.calculatedCellSize = CGSize(width: frameSize.width/10, height: frameSize.width/10)
        self.node = SKShapeNode(rectOf: calculatedCellSize, cornerRadius: 7)
        self.node.strokeColor = #colorLiteral(red: 0.1019607843, green: 0.1176470588, blue: 0.2784313725, alpha: 1).withAlphaComponent(0.5)
        self.node.lineWidth = 2.0
        self.node.position = position
        
        self.textureNode = SKSpriteNode(color: .clear, size: calculatedCellSize)
        self.node.addChild(textureNode)
    }
    
    
}
