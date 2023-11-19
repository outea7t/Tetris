//
//  ARGameView.swift
//  Tetris
//
//  Created by Out East on 13.11.2023.
//

import SwiftUI
import ARKit
import RealityKit


class ARGameViewController: UIViewController {
    
    /// view, которое отвечает за отрисовку объектов дополненной реальности
    let arscnView = ARSCNView()
    /// обнаруженная плоскость
    let detectedPlane = Plane()
    /// сцена, в которой располагаются все игровые объекты
    let gameScene = SCNScene()
    /// рамка с ячейками
    let frame = Frame3D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureScene()
        self.configureARSCNView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.arscnView.session.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateConfituration()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.frame.isPositionPinned = true
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
    
    private func updateConfituration() {
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
        self.arscnView.scene.physicsWorld.contactDelegate = self
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
            self.gameScene.rootNode.runAction(waitAction) {
                self.configureFrame()
                self.detectedPlane.wantSetPosition = false
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

// обработка столкновений
extension ARGameViewController: SCNPhysicsContactDelegate {
    
}
