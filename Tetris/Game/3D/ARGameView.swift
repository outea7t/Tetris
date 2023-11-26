//
//  ARGameView.swift
//  Tetris
//
//  Created by Out East on 15.11.2023.
//

import SwiftUI
import ARKit

struct ARGameView: View {
    @Binding var navigationPaths: [Routes]
    private var arGameViewController: ARGameViewControllerRepresentable {
        let controller = ARGameViewControllerRepresentable.shared
        ARGameViewController.shared.suiDelegate = self
        return controller
    }
    
    @State var destroyedLines: Int = 0
    @State var currentLevel: Int = 0
    @State var currentScore: Int = 0
    var maxScore: Int {
        get {
            return UserStatistics.maxScore
        }
    }
    
    var body: some View {
        ZStack {
            arGameViewController
                .ignoresSafeArea()
                .gesture(
                    //                 MARK: Drag Gesture
                    DragGesture(coordinateSpace: .global)
                        .onChanged({ touch in
                            if !self.moveVertical(touch: touch) {
                                self.moveHorizontal(touch: touch)
                            }
                        })
                    
                )
            //         MARK: OnTap Gesture
                .onTapGesture {
                    self.arGameViewController.onTapGesture()
                }
            VStack {
                // MARK: Statistics
                HStack {
                    // MARK: Current Destroyed Lines
                    PixelText(text: "\(self.destroyedLines)", fontSize: 30, color: .white)
                        .padding(.leading, 25)
                        .padding(.top)
                    
                    Spacer()
                    
                    // MARK: Current Level
                    PixelText(text: "\(self.currentLevel)", fontSize: 30, color: .white)
                        .padding(.trailing, 25)
                }
                
                VStack {
                    // MARK: Current Score
                    PixelText(text: "\(self.currentScore)", fontSize: 40, color: .white)
                    
                    // MARK: Max Score
                    PixelText(text: "\(self.maxScore)", fontSize: 25, color: .secondary)
                        .padding(.top, 10)
                }
                .padding(.top, 15)
                
                Spacer()
                
                // MARK: Pause Button
                HStack {
                    Spacer()
                    Button {
                        self.showPauseView()
                    } label: {
                        PixelText(text: "||", fontSize: 50, color: .white)
                            .padding(.trailing, 40)
                            .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func showPauseView() {
        self.arGameViewController.pauseGame()
        self.navigationPaths.append(.pauseView)
    }
    func showLoseView() {
        self.navigationPaths.append(.loseView)
    }
    private func moveHorizontal(touch: DragGesture.Value) {
        self.arGameViewController.moveHorizontal(touch: touch)
    }
    private func moveVertical(touch: DragGesture.Value) -> Bool {
        return self.arGameViewController.moveVertical(touch: touch)
    }
}

#Preview {
    ARGameView(navigationPaths: Binding.constant([]))
}
