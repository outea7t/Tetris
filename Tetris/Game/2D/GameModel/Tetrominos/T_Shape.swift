//
//  T_Shape.swift
//  Tetris
//
//  Created by Out East on 26.10.2023.
//

import Foundation
import SpriteKit

class T_Shape: Tetromino {
    
    override init() {
        super.init()
        
        self.type = .t
        self.positions = [Position(x: 4, y: 19),
                          Position(x: 3, y: 18),
                          Position(x: 4, y: 18),
                          Position(x: 5, y: 18),
        ]
    }
    override func rotateToLeft(cells: [[Cell]]) {
        super.rotateToLeft(cells: cells)
        
        var testPositions = [Position]()
        for position in positions {
            testPositions.append(Position(x: position.x, y: position.y))
        }
        testPositions[1] = Position(x: self.positions[1].x + 1, y: self.positions[1].y - 1)
        self.correctPosition(tempPositions: testPositions)
        
        guard checkIfCanRotate(cells: cells, positions: testPositions) else {
            return
        }
        
        self.positions[1].x += 1
        self.positions[1].y -= 1
        
        self.correctPosition(tempPositions: self.positions)
    }
    override func rotateToUpsideDown(cells: [[Cell]]) {
        super.rotateToUpsideDown(cells: cells)
        
        var testPositions = [Position]()
        for position in positions {
            testPositions.append(Position(x: position.x, y: position.y))
        }
        testPositions[0] = Position(x: self.positions[0].x - 1, y: self.positions[0].y - 1)
        self.correctPosition(tempPositions: testPositions)
        
        guard checkIfCanRotate(cells: cells, positions: testPositions) else {
            return
        }
        
        self.positions[0].x -= 1
        self.positions[0].y -= 1
        
        self.correctPosition(tempPositions: self.positions)
    }
    override func rotateToRight(cells: [[Cell]]) {
        super.rotateToRight(cells: cells)
        
        var testPositions = [Position]()
        for position in positions {
            testPositions.append(Position(x: position.x, y: position.y))
        }
        testPositions[3] = Position(x: self.positions[3].x - 1, y: self.positions[3].y + 1)
        self.correctPosition(tempPositions: testPositions)
        
        guard checkIfCanRotate(cells: cells, positions: testPositions) else {
            return
        }
        
        self.positions[3].x -= 1
        self.positions[3].y += 1
        
        self.correctPosition(tempPositions: self.positions)
    }
    override func rotateToCenter(cells: [[Cell]]) {
        super.rotateToCenter(cells: cells)
        
        var testPositions = [Position]()
        for position in positions {
            testPositions.append(Position(x: position.x, y: position.y))
        }
        testPositions[1] = Position(x: self.positions[1].x - 1, y: self.positions[1].y + 1)
        testPositions[0] = Position(x: self.positions[0].x + 1, y: self.positions[0].y + 1)
        testPositions[3] = Position(x: self.positions[3].x + 1, y: self.positions[3].y - 1)
        self.correctPosition(tempPositions: testPositions)
        
        guard checkIfCanRotate(cells: cells, positions: testPositions) else {
            return
        }
        
        self.positions[1].x -= 1
        self.positions[1].y += 1
        
        self.positions[0].x += 1
        self.positions[0].y += 1
        
        self.positions[3].x += 1
        self.positions[3].y -= 1
        
        self.correctPosition(tempPositions: self.positions)
    }
}
