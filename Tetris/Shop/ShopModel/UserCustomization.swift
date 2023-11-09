//
//  UserCustomization.swift
//  Tetris
//
//  Created by Out East on 01.11.2023.
//

import Foundation

struct UserCustomization {
    private enum UserCustomizationKeys: String {
        case _maxTetrominoSkinIndex
        case _currentTetrominoSkinIndex
        case _buyedSkinIndexes
    }
    /// максимальный индекс существующего скина
    static var maxTetrominoSkinIndex: Int = 1
    /// индекс текущего выбранного скина
    static var currentTetrominoSkinIndex: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserCustomizationKeys._currentTetrominoSkinIndex.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: UserCustomizationKeys._currentTetrominoSkinIndex.rawValue)
        }
    }
    /// индексу купленных скинов
    static var buyedSkinIndexes: [Int] {
        get {
            guard let array = UserDefaults.standard.array(forKey: UserCustomizationKeys._buyedSkinIndexes.rawValue) as? [Int] else {
                return []
            }
            return array
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: UserCustomizationKeys._buyedSkinIndexes.rawValue)
        }
    }
    
    /// количество купленных скинов (для статистики)
    static var countOfBuyedSkins: Int {
        get {
            return buyedSkinIndexes.count
        }
    }
}
