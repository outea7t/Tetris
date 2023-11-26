//
//  NavigationStackManager.swift
//  Tetris
//
//  Created by Out East on 10.11.2023.
//

import SwiftUI


enum Routes {
    case mainMenu
    case statisticsMenu
    case gameView
    case pauseView
    case loseView
    case arGameView
    case arPauseView
    case arLoseView
}

// Навигация в игре будет реализована через Navigation Stack
// последнее View которое мы будем добавлять в стэк, будет удаляться первым.
// соответственно мы сможем "перескакивать" в навигации сразу несколько View
struct NavigationStackManager: View {
    
    /// переменная для контроля текущего View
    /// последний элемент данного массива - текущее View
    ///
    /// если в массиве нет никаких элементов, то текущее View - MainMenu
    @State private var navigationPaths = [Routes]()
    
    var body: some View {
        
        VStack {
            // MARK: Navigation Stack
            NavigationStack(path: $navigationPaths) {
                // MARK: Main Menu
                MainMenu(navigationPaths: $navigationPaths)
                    .navigationDestination(for: Routes.self) { route in
                        switch route {
                        case .mainMenu:
                            MainMenu(navigationPaths: $navigationPaths)
                        case .statisticsMenu:
                            StatisticsView(navigationPaths: $navigationPaths)
                        case .gameView:
                            GameView(navigationPaths: $navigationPaths)
                        case .pauseView:
                            PauseView(currentScore: GameScene.shared.currentScore, backgroundOpacity: 1.0, navigationPaths: $navigationPaths)
                        case .arPauseView:
                            ARPauseView(currentScore: ARGameViewController.shared.currentScore, backgroundOpacity: 0.5, navigationPaths: $navigationPaths)
                        case .loseView:
                            LoseView(gainedScore: GameScene.shared.currentScore, 
                                     gainedMoney: GameScene.shared.gainedMoney.totalGainedMoney,
                                     navigationPaths: $navigationPaths
                            )
                        case .arLoseView:
                            ARLoseView(gainedScore: ARGameViewController.shared.currentScore,
                                     gainedMoney: ARGameViewController.shared.gainedMoney.totalGainedMoney,
                                     navigationPaths: $navigationPaths
                            )
                        case .arGameView:
                            ARGameView(navigationPaths: $navigationPaths)
                            
                        }
                    }
            }
        }
    }
}

#Preview {
    NavigationStackManager()
}
