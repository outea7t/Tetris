//
//  UserStatistics.swift
//  Tetris
//
//  Created by Out East on 06.11.2023.
//

import Foundation

struct UserStatistics {
    private enum UserStatisticsKeys: String {
        case _maxScore
        case _currentScore
        case _moneyCount
        case _moneyGained
        
    }
    /// максимальный счет игрока за всю
    /// обновляется в меню проигрыша
    static var maxScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserStatisticsKeys._maxScore.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: UserStatisticsKeys._maxScore.rawValue)
        }
    }
    /// текущий счет игрока
    /// обновляется при переходе из меню с игрой в меню проигрыша
    static var currentScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserStatisticsKeys._currentScore.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: UserStatisticsKeys._currentScore.rawValue)
        }
    }
    
    /// количество денег игрока
    /// обновляется в меню проигрыша
    static var moneyCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserStatisticsKeys._moneyCount.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: UserStatisticsKeys._moneyCount.rawValue)
        }
    }
    
    /// количество полученных игроком денег по завершению игры
    /// обновляеся при переходе из меню с игрой в меню проигрыша
    static var moneyGained: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserStatisticsKeys._moneyGained.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: UserStatisticsKeys._moneyGained.rawValue)
        }
    }
}
