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
        
//        HapticManager.prepare()
        return scene
    }
    
    @Binding var navigationPaths: [Routes]
    
    private let foreground3DButtonColor = #colorLiteral(red: 1, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
    private let background3DButtonColor = #colorLiteral(red: 0.168627451, green: 0.03529411765, blue: 0.03529411765, alpha: 1)
    
    
    var body: some View {
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
                    .frame(width: 350, height: 140)
                        .padding(.top, 20)

                Spacer()
                
                // MARK: Play Button
                Button {
                    navigationPaths.append(.gameView)
                } label: {
                    EndGameButton(text: "Play", textColor: .white, fontSize: 45)
                        .frame(width: 311, height: 86)
//                        .padding(.top, 120)
                        .background(.red)
                        
                }
//                .background(.red)
                
                
                
                // MARK: Shop Button
                EndGameButton(text: "Shop", textColor: .white, fontSize: 45)
                    .frame(height: 100)
                    .padding(.top, 30)
                
                HStack {
                    // MARK: Statistics Button
                    Button {
                        navigationPaths.append(.statisticsMenu)
                    } label: {
                        MenuRoundedButton(iconName: "star.fill", size: 75)
                    }
                    .padding(.top, 50)
                    .padding(.leading, 33)
                    
                    Spacer()
                }
                
                HStack {
                    Button {
                        self.navigationPaths.append(.arGameView)
                    } label: {
                        // MARK: TO 3D Button
                        MenuRoundedButton(foregroundColor: Color(foreground3DButtonColor), backgroundColor: Color(background3DButtonColor), iconName: "move.3d")
                            .padding(.top, 15)
                            .padding(.leading, 20)
                    }
                    Spacer()
                    
                    // MARK: Settings Button
                    MenuRoundedButton(iconName: "gearshape.fill")
                        .padding(.top, 15)
                        .padding(.trailing, 20)
                }
            }
        }
        .navigationTitle("")
        .toolbar(.hidden)
    }
}

#Preview {
    NavigationView {
        MainMenu(navigationPaths: .constant([Routes]()))
    }
}
