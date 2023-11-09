//
//  O_Shape.swift
//  Tetris
//
//  Created by Out East on 26.10.2023.
//

import Foundation
import SpriteKit

class O_Shape: Tetromino {
    
    override init() {
        super.init()
        
        self.type = .o
        self.positions = [Position(x: 4, y: 19),
                          Position(x: 5, y: 19),
                          Position(x: 4, y: 18),
                          Position(x: 5, y: 18)
        ]
    }
    override func rotateToLeft(cells: [[Cell]]) {
        super.rotateToLeft(cells: cells)
    }
    override func rotateToUpsideDown(cells: [[Cell]]) {
        super.rotateToUpsideDown(cells: cells)
    }
    override func rotateToRight(cells: [[Cell]]) {
        super.rotateToRight(cells: cells)
    }
    override func rotateToCenter(cells: [[Cell]]) {
        super.rotateToCenter(cells: cells)
    }
}
