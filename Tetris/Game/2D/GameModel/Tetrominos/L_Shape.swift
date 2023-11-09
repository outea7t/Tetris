//
//  L_Shape.swift
//  Tetris
//
//  Created by Out East on 26.10.2023.
//

import Foundation
import SpriteKit

class L_Shape: Tetromino {
    
    override init() {
        super.init()
        
        self.type = .l
        self.positions = [Position(x: 3, y: 18),
                          Position(x: 4, y: 18),
                          Position(x: 5, y: 18),
                          Position(x: 5, y: 19)]
    }
    override func rotateToLeft(cells: [[Cell]]) {
        super.rotateToLeft(cells: cells)
        
        var testPositions = [Position]()
        for position in positions {
            testPositions.append(Position(x: position.x, y: position.y))
        }
        testPositions[0] = Position(x: self.positions[0].x + 1, y: self.positions[0].y + 1)
        testPositions[2] = Position(x: self.positions[2].x - 1, y: self.positions[2].y - 1)
        testPositions[3] = Position(x: self.positions[3].x, y: self.positions[3].y - 2)
        self.correctPosition(tempPositions: testPositions)
        
        guard checkIfCanRotate(cells: cells, positions: testPositions) else {
            return
        }
        
        self.positions[0].x+=1
        self.positions[0].y+=1
        
        self.positions[2].x-=1
        self.positions[2].y-=1
        
        self.positions[3].y-=2
        
        self.correctPosition(tempPositions: self.positions)
    }
    override func rotateToUpsideDown(cells: [[Cell]]) {
        super.rotateToUpsideDown(cells: cells)
        
        var testPositions = [Position]()
        for position in positions {
            testPositions.append(Position(x: position.x, y: position.y))
        }
        testPositions[0] = Position(x: self.positions[0].x + 1, y: self.positions[0].y - 1)
        testPositions[2] = Position(x: self.positions[2].x - 1, y: self.positions[2].y + 1)
        testPositions[3] = Position(x: self.positions[3].x - 2, y: self.positions[3].y)
        self.correctPosition(tempPositions: testPositions)
        
        guard checkIfCanRotate(cells: cells, positions: testPositions) else {
            return
        }
        
        self.positions[0].x += 1
        self.positions[0].y -= 1
        
        self.positions[2].x -= 1
        self.positions[2].y += 1
        
        self.positions[3].x -= 2
        
        self.correctPosition(tempPositions: self.positions)
    }
    override func rotateToRight(cells: [[Cell]]) {
        super.rotateToRight(cells: cells)
        
        var testPositions = [Position]()
        for position in positions {
            testPositions.append(Position(x: position.x, y: position.y))
        }
        testPositions[0] = Position(x: self.positions[0].x - 1, y: self.positions[0].y - 1)
        testPositions[2] = Position(x: self.positions[2].x + 1, y: self.positions[2].y + 1)
        testPositions[3] = Position(x: self.positions[3].x, y: self.positions[3].y + 2)
        self.correctPosition(tempPositions: testPositions)
        
        guard checkIfCanRotate(cells: cells, positions: testPositions) else {
            return
        }
        
        self.positions[0].x -= 1
        self.positions[0].y -= 1
        
        self.positions[2].x += 1
        self.positions[2].y += 1
        
        self.positions[3].y += 2
        
        self.correctPosition(tempPositions: self.positions)
    }
    override func rotateToCenter(cells: [[Cell]]) {
        super.rotateToCenter(cells: cells)
        
        var testPositions = [Position]()
        for position in positions {
            testPositions.append(Position(x: position.x, y: position.y))
        }
        testPositions[0] = Position(x: self.positions[0].x - 1, y: self.positions[0].y + 1)
        testPositions[2] = Position(x: self.positions[2].x + 1, y: self.positions[2].y - 1)
        testPositions[3] = Position(x: self.positions[3].x + 2, y: self.positions[3].y)
        self.correctPosition(tempPositions: testPositions)
        
        guard checkIfCanRotate(cells: cells, positions: testPositions) else {
            return
        }
        
        self.positions[0].x -= 1
        self.positions[0].y += 1
        
        self.positions[2].x += 1
        self.positions[2].y -= 1
        
        self.positions[3].x += 2
        
        self.correctPosition(tempPositions: self.positions)
    }
    
    
}
