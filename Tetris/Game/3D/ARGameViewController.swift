//
//  ARGameView.swift
//  Tetris
//
//  Created by Out East on 13.11.2023.
//

import SwiftUI
import ARKit
import RealityKit

fileprivate class TouchTimeInformation {
    /// задержка после мгновенного спуска фигуры
    static var touchTimeDelay: TimeInterval = 0.3
    /// время последнего мгновенного спуска фигуры
    static var lastMoveToBottomTime: TimeInterval = 0.0
}
class ARGameViewController: UIViewController {
    static var shared = ARGameViewController()
    
    var suiDelegate: ARGameView?
    /// view, которое отвечает за отрисовку объектов дополненной реальности
    let arscnView = ARSCNView()
    /// должен ли обновлять ARWroldTrackingConfiguration
    /// вспомогательная переменная, чтобы не обновлять ее после меню паузы
    var shouldUpdateConfiguration = true
    /// обнаруженная плоскость
    let detectedPlane = Plane()
    /// сцена, в которой располагаются все игровые объекты
    let gameScene = SCNScene()
    /// рамка с ячейками
    let frame = Frame3D()
    
    var gainedMoney = MoneyGainingLogic()
    
    var isGamePaused = false
    
    var destroyedLines: Int = 0 {
        willSet {
            if let suiDelegate = self.suiDelegate {
                suiDelegate.destroyedLines = newValue
            }
        }
    }
    var currentScore: Int = 0 {
        willSet {
            if let suiDelegate = self.suiDelegate {
                suiDelegate.currentScore = newValue
            }
        }
    }
    var currentLevel: Int = 0 {
        willSet {
            if let suiDelegate = self.suiDelegate {
                suiDelegate.currentLevel = newValue
            }
        }
    }
    
    private var startTouchYPosition = CGFloat()
    private var startTouchXPosition = CGFloat()
    
    var isDelaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureScene()
        self.configureARSCNView()
        self.frame.addFirstThreeTetrominos()
//        self.frame.node.eulerAngles.y = Float.pi
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.arscnView.session.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.shouldUpdateConfiguration {
            self.updateConfituration()
        }
    }
    
//    override func update
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        withUnsafePointer(to: self.frame) { pointer in
            print("Memory address of a frame: \(pointer)")
        }
        super.touchesBegan(touches, with: event)
        if !self.frame.isPositionPinned {
            self.frame.isPositionPinned = true
            self.detectedPlane.setOpacityToShadowOnly()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return []
    }
    
    func pauseGame() {
        self.isGamePaused = true
    }
    func unpauseGame() {
        self.isGamePaused = false
    }
    
    func clearCells() {
        
    }
    func changeTetrominoInNextView(type: TetrominoType) {
        
    }
    func moveVertical(touch: DragGesture.Value) -> Bool {
       
        guard !self.isGamePaused && self.frame.isPositionPinned else {
            return false
        }
        guard abs(touch.location.y - self.startTouchYPosition) >= 25 else {
            return false
        }
        
        self.startTouchYPosition = touch.startLocation.y
        for shape in self.frame.shapes {
            if shape.isLocked {
                continue
            }
            guard abs(touch.velocity.height) < 1000 else {
                guard touch.time.timeIntervalSince1970 - TouchTimeInformation.lastMoveToBottomTime >= TouchTimeInformation.touchTimeDelay else {
                    return true
                }
                TouchTimeInformation.lastMoveToBottomTime = touch.time.timeIntervalSince1970
                self.gainedMoney.numberOfPullDowns+=1
                shape.moveToBottom(arGameViewController: self)
                self.startTouchYPosition = 0
                return true
            }
            if touch.location.y - self.startTouchYPosition > 0 {
                shape.moveDown(cells: frame.cells)
                frame.updateCells()
            }
        }
        self.startTouchYPosition = touch.location.y
        return true
    }
    
    func moveHorizontal(touch: DragGesture.Value) {
        withUnsafePointer(to: self.frame) { pointer in
            print("Memory address of a frame: \(pointer)")
        }
        guard !self.isGamePaused && self.frame.isPositionPinned else {
            return
        }
        guard abs(touch.location.x - self.startTouchXPosition) >= 25 else {
            return
        }
        
        self.startTouchXPosition = touch.startLocation.x
        for shape in self.frame.shapes {
            if shape.isLocked {
                continue
            }
            if self.startTouchXPosition - touch.location.x > 0 {
                shape.moveToRight(cells: self.frame.cells)
                self.frame.updateCells()
            } else if self.startTouchXPosition - touch.location.x < 0  {
                shape.moveToLeft(cells: self.frame.cells)
                self.frame.updateCells()
            }
        }
        self.startTouchXPosition = touch.location.x
    }
    
    func onTapGesture() {
        guard !self.isGamePaused && self.frame.isPositionPinned else {
            return
        }
        
        for shape in self.frame.shapes {
            shape.rotate(cells: self.frame.cells)
        }
        self.frame.updateCells()
    }
    
    func resetGame() {
        self.isGamePaused = false
        self.destroyedLines = 0
        self.currentScore = 0
        self.currentLevel = 0
        self.frame.clearCells()
        self.frame.addFirstThreeTetrominos()
//        self.nextShapeView_?.addNextTetrominos(frame: frame)
//        self.nextShapeView_?.clearAllTetrominos()
    }
    
    func setLose() {
        self.arscnView.session.pause()
        self.gainedMoney.numberOfDestroyedLines = self.destroyedLines
        self.isGamePaused = true
        self.suiDelegate?.showLoseView()
    }
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !self.isGamePaused && self.frame.isPositionPinned else {
            return
        }
        
        self.frame.update(time, in: self)
    }
    private func updateConfituration() {
        print("CONFIGURATION UPDATED")
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        configuration.environmentTexturing = .none
        
        self.arscnView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
    
    private func configureScene() {
        self.gameScene.rootNode.name = "rootNode"
        
        self.gameScene.physicsWorld.gravity = SCNVector3(0.0, 0.0, 0.0)
        self.gameScene.rootNode.physicsBody = SCNPhysicsBody()
        self.gameScene.rootNode.physicsBody?.damping = 0.0
        self.gameScene.rootNode.physicsBody?.friction = 0.0
        self.gameScene.rootNode.physicsBody?.restitution = 1.0
        self.gameScene.rootNode.physicsBody?.angularDamping = 0.0
        
        self.arscnView.scene = self.gameScene
    }
    
    private func configureARSCNView() {
        // инициализируем и добавляем в иерархию view
        self.arscnView.frame = self.view.bounds
        self.arscnView.center = self.view.center
        self.view.addSubview(self.arscnView)
        
        self.arscnView.delegate = self

        self.arscnView.allowsCameraControl = false
        self.arscnView.autoenablesDefaultLighting = true
        
        // настраиваем debug-опции
        self.arscnView.debugOptions = [
            .showWorldOrigin,
            .showLightExtents,
            .showFeaturePoints,
            .showPhysicsShapes
        ]
        // делегат для работы функций контакта
//        self.arscnView.scene.physicsWorld.contactDelegate = self
        // устанавливаем предпочтительное количество кадров в секунду у view
        self.arscnView.preferredFramesPerSecond = 60
        self.arscnView.rendersMotionBlur = true
        
        // настраиваем констрейнты для arscnView
        var constraints = [NSLayoutConstraint]()
        self.arscnView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(
            self.arscnView.topAnchor.constraint(equalTo: self.view.topAnchor)
        )
        constraints.append(
            self.arscnView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        )
        constraints.append(
            self.arscnView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        )
        constraints.append(
            self.arscnView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        )
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureFrame() {
        guard let detectedPlaneNode = self.detectedPlane.detectedPlaneNode else {
            return
        }
        self.frame.addFrame(to: self.gameScene.rootNode, in: detectedPlaneNode.worldPosition)
    }
}

// обнаружение плоскости
extension ARGameViewController: ARSCNViewDelegate {
    // функция, которая обнаруживает плоскость
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        self.detectedPlane.initializePlane(planeAnchor: planeAnchor, addTo: self.gameScene.rootNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        self.detectedPlane.updatePlane(planeAnchor: planeAnchor)
        
        // добавляем рамку с игровыми объектами, если она еще не добавлена
        
        if self.detectedPlane.wantSetPosition && !self.detectedPlane.wantDetectPlane {
            let waitAction = SCNAction.wait(duration: 2.0)
            self.detectedPlane.wantSetPosition = false
            self.gameScene.rootNode.runAction(waitAction) {
                self.configureFrame()
                HapticManager.collisionVibrate(with: .medium, 1.0)
            }
        }
        
        // если позиция рамки не закреплена, то двигаем ее
        // в соответствие с движением телефона
        guard !self.frame.isPositionPinned else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let arscnView = self?.arscnView,
                  let frame = self?.frame
            else {
                return
            }
            
            let raycast = arscnView.raycastQuery(from: arscnView.center, allowing: .existingPlaneGeometry, alignment: .horizontal)
            
            guard let raycast = raycast else {
                return
            }
            
            let results = arscnView.session.raycast(raycast)
            
            guard let result = results.first else {
                return
            }
            
            let hitPosition = result.worldTransform.columns.3
            let desirablePosition = SCNVector3(hitPosition.x,
                                               hitPosition.y + frame.frameBottomVolume.y,
                                               hitPosition.z
            )
            let moveAction = SCNAction.move(to: desirablePosition, duration: 0.25)
            frame.node.runAction(moveAction)
        }
    }
    
}

extension ARGameViewController: SCNPhysicsContactDelegate {
    
}
