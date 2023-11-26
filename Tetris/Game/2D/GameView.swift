//
//  GameView.swift
//  Tetris
//
//  Created by Out East on 18.10.2023.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
    var scene: GameScene {
        let scene = GameScene.shared
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .fill
        scene.suiViewDelegate = self
        return scene
    }
    
    @State var startTouchXPosition = CGFloat()
    @State var startTouchYPosition = CGFloat()
    @State var destroyedLines: Int = 0
    @State var currentScore: Int = 0 {
        willSet {
            if newValue > UserStatistics.maxScore {
                UserStatistics.maxScore = newValue
            }
        }
    }
    @State var currentLevel: Int = 1
    
    var gainedMoney: Int = 0
    @Binding var navigationPaths: [Routes]
    
    var body: some View {
        
        // MARK: SpriteKit View
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .gesture(
                    // MARK: Drag Gesture
                    DragGesture(coordinateSpace: .global)
                        .onChanged({ touch in
                            guard !self.scene.isGamePaused else {
                                return
                            }
                            
                            if !self.moveVertical(touch: touch) {
                                self.moveHorizontal(touch: touch)
                            }
                        })
                    
                )
                // MARK: OnTap Gesture
                .onTapGesture {
                    self.scene.onTapGesture()
                }
            
            VStack {
                HStack {
                    // MARK: Current Destroyed Lines
                    Text("Lines: \(self.destroyedLines)")
                        .font(.custom("04b", size: 20))
                        .foregroundStyle(.white)
                        .padding(.leading, 25)
                    
                    Spacer()
                    
                    // MARK: Current Level
                    Text("Level: \(self.currentLevel)")
                        .font(.custom("04b", size: 20))
                        .foregroundStyle(.white)
                        .padding(.trailing, 25)
                }
                
                VStack {
                    // MARK: Current Score
                    Text("\(self.currentScore)")
                        .font(.custom("04b", size: 32))
                        .foregroundStyle(.white)
                    
                    // MARK: Max Score
                    Text("261,130")
                        .font(.custom("04b", size: 15))
                        .foregroundStyle(.white)
                        .padding(.top, 10)
                }
                .padding(.top, 15)
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            HStack {
                // MARK: Pause Button
                Spacer()
                Button {
                    self.navigationPaths.append(.pauseView)
                    self.scene.pauseGame()
                } label: {
                    Text("||")
                        .font(.custom("04b", size: 35))
                        .foregroundStyle(.white)
                        .padding(.trailing)
                }
                
            }
            .frame(maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .navigationBarHidden(true)
    }
    
    func showLoseView() {
        navigationPaths.append(.loseView)
    }
    /// двигает текущую деталь по горизонтали
    private func moveHorizontal(touch: DragGesture.Value) {
        self.scene.moveShapeHorizontal(touch: touch)
    }
    
    /// двигает текущую деталь по вертикали
    private func moveVertical(touch: DragGesture.Value) -> Bool {
        self.scene.moveShapeVertical(touch: touch)
    }
}

#Preview {
    GameView(navigationPaths: .constant([]))
}
