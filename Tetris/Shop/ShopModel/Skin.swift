//
//  Skin.swift
//  Tetris
//
//  Created by Out East on 03.12.2023.
//

import Foundation

class Skin: Identifiable {
    var id: UUID
    var skinID: Int
    var skinPrice: Int
    var isSelected: Bool
    var isBuyed: Bool
    init(skinID: Int, skinPrice: Int, isSelected: Bool, isBuyed: Bool) {
        self.skinID = skinID
        self.skinPrice = skinPrice
        self.id = UUID()
        
        self.isSelected = isSelected
        self.isBuyed = isBuyed
    }
    
}
