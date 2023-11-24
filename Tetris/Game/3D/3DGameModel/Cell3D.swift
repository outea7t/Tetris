//
//  Cell3D.swift
//  Tetris
//
//  Created by Out East on 13.11.2023.
//

import Foundation
import SceneKit

class Cell3D: Cell {
    let mutex = NSLock()
    let node = SCNNode()
    var calculatedCellVolume = SCNVector3()
    
    var hasCurrentTetrominoIn = false {
        willSet {
            if newValue {
                self.fillColor = .red
            } else {
                self.fillColor =  #colorLiteral(red: 0.2851957083, green: 0.2851957083, blue: 0.2851957083, alpha: 1)
//                self.fillTexture = nil
            }
        }
    }
    
    var hasCurrentTetrominoProjectionIn = false {
        willSet {
            if newValue {
                self.fillColor = #colorLiteral(red: 0.7393465638, green: 0.7393465638, blue: 0.7393465638, alpha: 1)
//                let image = UIImage(named: "Projection")!
//                let texture = SKTexture(image: image)
//                if self.fillTexture == nil {
//                    self.fillTexture = texture
//                }
            } else {
                self.fillColor =  #colorLiteral(red: 0.2851957083, green: 0.2851957083, blue: 0.2851957083, alpha: 1)
//                self.fillTexture = nil
            }
        }
    }
    
    var isLocked = false {
        willSet {
            if newValue {
                fillColor = .red
            } else {
                fillColor = .clear
            }
        }
        
    }
    
    var fillColor: UIColor = .clear {
        willSet {
            mutex.lock()
            defer {
                mutex.unlock()
            }
            let material = SCNMaterial()
            if newValue == .clear {
                material.diffuse.contents = #colorLiteral(red: 0.2851957083, green: 0.2851957083, blue: 0.2851957083, alpha: 1)
            } else {
                material.diffuse.contents = newValue
            }
            self.node.geometry?.materials = [material]
        }
    }
    
    init(frameVolume: SCNVector3, position: SCNVector3) {
        self.calculatedCellVolume = SCNVector3(frameVolume.x/10.0,
                                               frameVolume.x/10.0,
                                               frameVolume.x/10.0)
        
        let geometry = SCNBox(width: CGFloat(self.calculatedCellVolume.x),
                              height: CGFloat(self.calculatedCellVolume.y),
                              length: CGFloat(self.calculatedCellVolume.z),
                              chamferRadius: 0.001)
        
        let material = SCNMaterial()
        material.diffuse.contents = #colorLiteral(red: 0.2851957083, green: 0.2851957083, blue: 0.2851957083, alpha: 1)
        geometry.materials = [material]
        
        self.node.geometry = geometry
        self.node.position = position
    }
    
}
