//
//  Plane.swift
//  Tetris
//
//  Created by Out East on 18.11.2023.
//

import Foundation
import ARKit
import SceneKit

/// Плоскость, на которой будут размещаться игровые объекты
class Plane {
    /// хотим ли мы добавлять новую плоскость
    /// если таковая уже добавлена, то переменная будет false
    var wantDetectPlane = true
    /// нужно ли создавать на обнаруженной плоскости сцену с игровыми объектами
    var wantSetPosition = true
    
    /// все обнаруженные, принадлежащие плоскости вершины
    var planeAnchors = [ARPlaneAnchor]()
    
    /// текущая позиция обнаруженной поверхности в мировых координатах
    var planeNodePosition: SCNVector3?
    
    var detectedPlaneNode: SCNNode?
    func initializePlane(planeAnchor: ARPlaneAnchor, addTo node: SCNNode) {
        guard self.wantDetectPlane else {
            return
        }
        
        
        let width = CGFloat(planeAnchor.planeExtent.width)
        let height = CGFloat(planeAnchor.planeExtent.height)
        
        let plane = SCNPlane(width: width, height: height)
        
        let planeMaterial = SCNMaterial()
        let texture = SKTexture(imageNamed: "DetectedPlane.png")
        planeMaterial.diffuse.contents = texture
        planeMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(5, -5, 0)
        planeMaterial.diffuse.wrapS = .repeat
        planeMaterial.diffuse.wrapT = .repeat
        
        plane.materials = [planeMaterial]
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.name = "plane"
        
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        print(x,y,z)
        
        planeNode.position = SCNVector3(x: Float(x), y: 0, z: Float(z))
        self.detectedPlaneNode = planeNode
        
        node.addChildNode(planeNode)
        
        planeNode.simdTransform = planeAnchor.transform
        
        planeNode.eulerAngles.x = -.pi/2.0
        
        self.wantDetectPlane = false
        self.planeAnchors.append(planeAnchor)
    }
    
    func updatePlane(planeAnchor: ARPlaneAnchor) {
        guard let planeNode = self.detectedPlaneNode else {
            return
        }
        
        guard let planeGeometry = planeNode.geometry as? SCNPlane else {
            return
        }
        
        let width = CGFloat(planeAnchor.planeExtent.width)
        let height = CGFloat(planeAnchor.planeExtent.height)
        
        planeGeometry.width = width
        planeGeometry.height = height
        
        if !self.planeAnchors.contains(planeAnchor) {
            self.planeAnchors.append(planeAnchor)
        }
    }
    
    func setOpacityToShadowOnly() {
        let newPlaneMaterial = SCNMaterial()
        newPlaneMaterial.lightingModel = .shadowOnly
        self.detectedPlaneNode?.geometry?.materials = [newPlaneMaterial]
    }
    
    func resetPlane(session: ARSession) {
        for anchor in planeAnchors {
            session.remove(anchor: anchor)
        }
        
        planeAnchors.removeAll()
        
        self.detectedPlaneNode?.removeFromParentNode()
        
        self.wantDetectPlane = true
        self.wantSetPosition = true
    }
}
