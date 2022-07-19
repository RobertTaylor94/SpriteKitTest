//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by Robert on 19/07/2022.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
    }
    
}
