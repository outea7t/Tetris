//
//  MoneyGainingLogic.swift
//  Tetris
//
//  Created by Out East on 26.11.2023.
//

import Foundation

struct MoneyGainingLogic {
    var numberOfPullDowns: Int = 0
    var numberOfDestroyedLines: Int = 0
    
    var totalGainedMoney: Int {
        return Int(Double(numberOfPullDowns) * 0.3 + Double(numberOfDestroyedLines) * 1.2)
    }
}
