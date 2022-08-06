//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by Robert on 19/07/2022.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Variables
    var player = SKShapeNode()
    var ground = SKSpriteNode()
    var obstacle = SKSpriteNode()
    var obstacleTwo = SKSpriteNode()
    var obstacleContainer = SKSpriteNode()
    var gameOverText = SKLabelNode()
    var startButton = SKLabelNode()
    var isGameStarted = false
    var isGameOver = false
    var scoreLabel = SKLabelNode()
    var playerScore = 0
    var background = SKSpriteNode()
    var leftPoint = SKSpriteNode()
    
    //constants
    let displaySize: CGRect = UIScreen.main.bounds
    let obstacleKey = "RemoveObstacleKey"
    let gameLayer = SKNode()
    
    func pauseGame(_ state: Bool? = nil) {
        gameLayer.isPaused = state ?? !gameLayer.isPaused
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        spawnGround()
        beginButton()
        spawnPlayer()
//        spawnLeftPoint()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isGameStarted == false && isGameOver == false {
            spawnObstacles()
//            spawnLeftPoint()
            player.physicsBody?.affectedByGravity = true
            isGameStarted.toggle()
            startButton.removeFromParent()
            playerScore = 0
            spawnScoreLabel(position: CGPoint(x: displaySize.midX, y: displaySize.maxY - 100))
        }
        
        if isGameOver == true {
            resetGame()
            gameOverText.removeFromParent()
            scoreLabel.removeFromParent()
        }
        if isGameOver == false && isGameStarted == true {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 11))
        }
    }
    
    //MARK: Collisions
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "player" || contact.bodyB.node?.name == "player" {
            gameOver()
        }
        
//        if contact.bodyA.node?.name == "leftPoint" || contact.bodyB.node?.name == "leftPoint" {
//            print("POINT :)")
//            playerScore += 1
//            scoreLabel.removeFromParent()
//            spawnScoreLabel(position: CGPoint(x: displaySize.midX, y: displaySize.maxY - 100))
//            leftPoint.removeFromParent()
//            spawnLeftPoint()
//        }
    }
    
    //MARK: Spawn Player
    
    func spawnPlayer() {
//        let playerTexture = SKTexture(imageNamed: "player")
        player = SKShapeNode(circleOfRadius: 15)
        player.position = CGPoint(x: displaySize.midX, y: (displaySize.maxY/2)-50)
        player.zPosition = 5
        player.fillColor = .red
        player.physicsBody = SKPhysicsBody(circleOfRadius: 12)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.collisionBitMask = 1
        player.physicsBody?.contactTestBitMask = 1
        player.name = "player"
        addChild(player)
    }
    
    func spawnGround() {
        ground.color = .green
        ground.size = CGSize(width: frame.width, height: frame.height/5)
        ground.position = CGPoint(x: frame.midX, y: 0)
        ground.zPosition = 10
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.categoryBitMask = 1
        ground.physicsBody?.contactTestBitMask = 1
        addChild(ground)
    }
    
    //MARK: Spawn Obstacles
    
    func spawnObstacles() {
        
        let timer = SKAction.wait(forDuration: 2)
        
        let spawnContainer = SKAction.run { [self] in
            obstacleContainer = SKSpriteNode(color: .clear, size: CGSize(width: 100, height: frame.height))
            obstacleContainer.anchorPoint = CGPoint(x: 0.5, y: 0)
            obstacleContainer.position = CGPoint(x: frame.width + 100, y: 0)
            self.addChild(obstacleContainer)
            
            let moveContainer = SKAction.move(to: CGPoint(x: -50, y: 0), duration: 5)
            obstacleContainer.run(moveContainer)
        }
        
        let spawnObstacles = SKAction.run { [self] in
            
            let height = UInt32(frame.height / 6)
            let y = Double(arc4random_uniform(height) + height)
            
            obstacle = SKSpriteNode(color: .red, size: CGSize(width: 20, height: frame.height/1.5))
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
            obstacle.physicsBody?.affectedByGravity = false
            obstacle.physicsBody?.isDynamic = false
            obstacle.position = CGPoint(x: 0.0, y: y)
            
            obstacleTwo = SKSpriteNode(color: .red, size: CGSize(width: 20, height: frame.height/1.5))
            obstacleTwo.physicsBody = SKPhysicsBody(rectangleOf: obstacleTwo.size)
            obstacleTwo.physicsBody?.affectedByGravity = false
            obstacleTwo.physicsBody?.isDynamic = false
            obstacleTwo.position = CGPoint(x: 0.0, y: y + Double(obstacleTwo.size.height) + 150)
            
            obstacleContainer.addChild(obstacle)
            obstacleContainer.addChild(obstacleTwo)
        }
        
        let sequence = SKAction.sequence([spawnContainer, spawnObstacles, timer])
        self.run(SKAction.repeatForever(sequence), withKey: obstacleKey)
    }
    
//    func obstacleHeight() -> CGFloat {
//        let height = Int.random(in: Int((frame.height)/3)...Int((frame.height)/1.2))
//        return CGFloat(height)
//    }
    
    func gameOver() {
        scene?.removeAllChildren()
        
        player.removeFromParent()
        gameOverText = SKLabelNode(fontNamed: "Chalkduster")
        gameOverText.text = "GAME OVER"
        gameOverText.fontColor = .red
        gameOverText.fontSize = 30
        gameOverText.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(gameOverText)
        
//        spawnScoreLabel(position: CGPoint(x: displaySize.midX, y: displaySize.maxY - 300))
        
        obstacle.removeFromParent()
        obstacleTwo.removeFromParent()
        removeAction(forKey: obstacleKey)
        isGameOver = true
        isGameStarted = false
        print("game over")
        print("game over =\(isGameOver)")
        print("is game started= \(isGameStarted)")
        print("Frame height: \(frame.height)")
        spawnGround()
    }
    
    func beginButton() {
        startButton = SKLabelNode(fontNamed: "Chalkduster")
        startButton.text = "Start"
        startButton.fontColor = .yellow
        startButton.fontSize = 50
        startButton.position = CGPoint(x: displaySize.midX, y: displaySize.maxY/2)
        self.addChild(startButton)
    }
    
    func resetGame() {

        spawnPlayer()
        beginButton()
        gameOverText.removeFromParent()
        isGameOver = false
        isGameStarted = false
        
    }
    
    func spawnBackground() {
        background = SKSpriteNode(texture: SKTexture(imageNamed: "background"), size: CGSize(width: CGFloat(displaySize.width), height: CGFloat(displaySize.height)))
        background.position = CGPoint(x: 0, y: (displaySize.midY))
        
        
        addChild(background)
    }
    
    //MARK: Scoring
    
    //To detect obstacle collision
    //BROKEN
//    func spawnLeftPoint() {
//
//        let timer = SKAction.wait(forDuration: 2)
//
//        let spawnPoint = SKAction.run{ [self] in
//            leftPoint = SKSpriteNode(color: .yellow, size: CGSize(width: 5, height: 20))
//            leftPoint.position = CGPoint(x: frame.midX-50, y: frame.minY+200)
//            leftPoint.name = "leftPoint"
//            leftPoint.physicsBody = SKPhysicsBody(rectangleOf: leftPoint.size)
//            leftPoint.physicsBody?.categoryBitMask = 1
//            leftPoint.physicsBody?.contactTestBitMask = 1
//            leftPoint.physicsBody?.affectedByGravity = false
//    //        leftPoint.physicsBody?.isDynamic = false
//            addChild(leftPoint)
//        }
//
//        let sequence = SKAction.sequence([timer, spawnPoint])
//        self.run(sequence)
//
//    }
//
    
    func addPoint() {
        let timer = SKAction.wait(forDuration: 4)
        
        let addPoint = SKAction.run {
            self.playerScore += 1
            self.scoreLabel.removeFromParent()
            self.spawnScoreLabel(position: CGPoint(x: self.frame.midX, y: self.frame.maxY - 100))
        }
        
        let sequence = SKAction.sequence([timer, addPoint])
        self.run(sequence)
    }
    
    //Add 1 point for each obstacle passed
    func spawnScoreLabel(position: CGPoint) {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.zPosition = 15
        scoreLabel.text = "\(playerScore)"
        scoreLabel.fontColor = .yellow
        scoreLabel.fontSize = 50
        scoreLabel.position = position
        addChild(scoreLabel)
    }
    
    
}
