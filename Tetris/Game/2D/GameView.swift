//
//  GameView.swift
//  Tetris
//
//  Created by Out East on 18.10.2023.
//

import SwiftUI
import SpriteKit

fileprivate class TouchTimeInformation {
    /// задержка после мгновенного спуска фигуры
    static var touchTimeDelay: TimeInterval = 0.3
    /// время последнего мгновенного спуска фигуры
    static var lastMoveToBottomTime: TimeInterval = 0.0
}
struct GameView: View {
    
    var scene: GameScene {
        let scene = GameScene.shared
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .fill
        scene.suiViewDelegate = self
        return scene
    }
    @State var shouldGoToPauseView = false
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
                    guard !self.scene.isGamePaused else {
                        return
                    }
                    for shape in self.scene.shapes {
                        shape.rotate(cells: self.scene.cells)
                    }
                    self.scene.updateCells()
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
                    self.shouldGoToPauseView.toggle()
                    self.scene.pauseGame()
                } label: {
                    Text("||")
                        .font(.custom("04b", size: 35))
                        .foregroundStyle(.white)
                        .padding(.bottom, 30)
                        .padding(.trailing, 25)
                }
                .fullScreenCover(isPresented: $shouldGoToPauseView) {
                    print("")
                } content: {
                    PauseView(currentScore: currentScore)
                }
                
            }
            .frame(maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .navigationBarHidden(true)
    }
    
    /// двигает текущую деталь по горизонтали
    private func moveHorizontal(touch: DragGesture.Value) {
        guard abs(touch.location.x - self.startTouchXPosition) >= 25 else {
            return
        }
        
        self.startTouchXPosition = touch.startLocation.x
        for shape in self.scene.shapes {
            if shape.isLocked {
                continue
            }
            if self.startTouchXPosition - touch.location.x > 0 {
                shape.moveToLeft(cells: self.scene.cells)
                scene.updateCells()
            } else if self.startTouchXPosition - touch.location.x < 0  {
                shape.moveToRight(cells: self.scene.cells)
                self.scene.updateCells()
            }
        }
        self.startTouchXPosition = touch.location.x
    }
    
    /// двигает текущую деталь по вертикали
    private func moveVertical(touch: DragGesture.Value) -> Bool {
        guard abs(touch.location.y - self.startTouchYPosition) >= 25 else {
            return false
        }
        
        print(touch.startLocation.y, touch.location.y, touch.velocity.height)
        self.startTouchYPosition = touch.startLocation.y
        for shape in self.scene.shapes {
            if shape.isLocked {
                continue
            }
            guard abs(touch.velocity.height) < 1000 else {
                guard touch.time.timeIntervalSince1970 - TouchTimeInformation.lastMoveToBottomTime >= TouchTimeInformation.touchTimeDelay else {
                    return true
                }
                TouchTimeInformation.lastMoveToBottomTime = touch.time.timeIntervalSince1970
                shape.moveToBottom(cells: self.scene.cells)
                self.startTouchYPosition = 0
                return true
            }
            if touch.location.y - self.startTouchYPosition > 0 {
                shape.moveDown(cells: self.scene.cells)
                scene.updateCells()
            }
        }
        self.startTouchYPosition = touch.location.y
//        print(self.startTouchYPosition)
        return true
    }
    func showLoseView() {
        
    }
    func showPauseView() {
        
    }
}

#Preview {
    GameView()
}
