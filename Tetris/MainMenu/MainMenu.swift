//
//  MainMenu.swift
//  Tetris
//
//  Created by Out East on 11.10.2023.
//

import SwiftUI
import SpriteKit

// MARK: Main Menu
struct MainMenu: View {
    var backdroundAnimationScene: SKScene {
        let scene = BackgroundAnimation()
        scene.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0, blue: 0.09019607843, alpha: 1)
        scene.size = CGSize(width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        
        HapticManager.prepare()
        return scene
    }
    
    @State private var shouldShowStatisticsView = false
    
    private let foreground3DButtonColor = #colorLiteral(red: 1, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
    private let background3DButtonColor = #colorLiteral(red: 0.168627451, green: 0.03529411765, blue: 0.03529411765, alpha: 1)
    var body: some View {
        NavigationView {
            ZStack {
                
                // MARK: Background
                GameColor.backgroundColor
                    .ignoresSafeArea()
                SpriteView(scene: self.backdroundAnimationScene)
                    .ignoresSafeArea()
                    .blur(radius: 20)
                    
                VStack {
                    // MARK: Game Logo
                    GameLogo()
                        .frame(width: 390, height: 200)
                        .padding(.top, 20)
                    
                    // MARK: Play Button
                    NavigationLink {
                        GameView()
                    } label: {
                        EndGameButton(text: "Play", textColor: .white, fontSize: 45)
                            .frame(height: 100)
                    }
                    .padding(.top, 120)
                    
                    // MARK: Shop Button
                    EndGameButton(text: "Shop", textColor: .white, fontSize: 45)
                        .frame(height: 100)
                        .padding(.top, 30)
                    
                    // MARK: Statistics Button
                    Button {
                        shouldShowStatisticsView.toggle()
                    } label: {
                        MenuRoundedButton(iconName: "star.fill", size: 75)
                            .padding(.top, 50)
                            .padding(.leading, 33)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .fullScreenCover(isPresented: $shouldShowStatisticsView) {
                    } content: {
                        StatisticsView()
                    }
                    
                    HStack {
                        // MARK: TO 3D Button
                        MenuRoundedButton(foregroundColor: Color(foreground3DButtonColor), backgroundColor: Color(background3DButtonColor), iconName: "move.3d")
                            .padding(.top, 15)
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        // MARK: Settings Button
                        MenuRoundedButton(iconName: "gearshape.fill")
                            .padding(.top, 15)
                            .padding(.trailing, 20)
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        MainMenu()
    }
}
