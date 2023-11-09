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
        case _moneyCount
    }
    
    static var maxScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserStatisticsKeys._maxScore.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: UserStatisticsKeys._maxScore.rawValue)
        }
    }
    
    static var moneyCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserStatisticsKeys._moneyCount.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: UserStatisticsKeys._moneyCount.rawValue)
        }
    }
}
