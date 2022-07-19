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
    var player = SKSpriteNode()
    var ground = SKSpriteNode()
    var obstacle = SKSpriteNode()
    var obstacleTwo = SKSpriteNode()
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
        
        print("setup")
        print("is game over = \(isGameOver)")
        print("is game started = \(isGameStarted)")
        
        beginButton()
        //spawnBackground()
        spawnPlayer()
        spawnGround()
        spawnLeftPoint()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isGameStarted == false && isGameOver == false {
            spawnObstacle()
            spawnLeftPoint()
            player.physicsBody?.affectedByGravity = true
            isGameStarted.toggle()
            startButton.removeFromParent()
            playerScore = 0
            spawnScoreLabel(position: CGPoint(x: frame.midX, y: frame.maxY - 50))
        }
        
        if isGameOver == true {
            resetGame()
            gameOverText.removeFromParent()
            scoreLabel.removeFromParent()
        }
        if isGameOver == false && isGameStarted == true {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        }
        
        
        print("is game started = \(isGameStarted)")
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "player" || contact.bodyB.node?.name == "player" {
            gameOver()
        }
        
        if contact.bodyA.node?.name == "leftPoint" || contact.bodyB.node?.name == "leftPoint" {
            playerScore += 1
            print(playerScore)
            scoreLabel.removeFromParent()
            spawnScoreLabel(position: CGPoint(x: frame.midX, y: frame.maxY - 50))
        }
    }
    
    func spawnPlayer() {
        let playerTexture = SKTexture(imageNamed: "player")
        player = SKSpriteNode(texture: playerTexture, size: CGSize(width: 75, height: 75))
        player.position = CGPoint(x: 200, y: 200)
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.collisionBitMask = 1
        player.physicsBody?.contactTestBitMask = 1
        player.name = "player"
        addChild(player)
    }
    
    func spawnGround() {
        ground.color = .green
        ground.size = CGSize(width: displaySize.width, height: 10)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.categoryBitMask = 1
        ground.physicsBody?.contactTestBitMask = 1
        ground.position = CGPoint(x: -1, y: 10)
        addChild(ground)
    }
    
    func spawnObstacle() {
        
        let timer = SKAction.wait(forDuration: 2)
        
        let spawnObstacles = SKAction.run { [self] in
            obstacle = SKSpriteNode(color: .gray, size: CGSize(width: 10, height: obstacleHeight()))
            obstacle.position = CGPoint(x: 600, y: 0)
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
            obstacle.physicsBody?.affectedByGravity = false
            obstacle.physicsBody?.isDynamic = false
            
            obstacleTwo = SKSpriteNode(color: .gray, size: CGSize(width: 10, height: 200))
            let obstacleHeight = obstacle.size.height
            obstacleTwo.position = CGPoint(x: 600, y: (obstacleHeight + 50))
            obstacleTwo.physicsBody = SKPhysicsBody(rectangleOf: obstacleTwo.size)
            obstacleTwo.physicsBody?.affectedByGravity = false
            obstacleTwo.physicsBody?.isDynamic = false
            
            addChild(obstacle)
            addChild(obstacleTwo)
            
            let moveObstacle = SKAction.move(to: CGPoint(x: -50, y: 10), duration: 5)
            let moveObstacleTwo = SKAction.move(to: CGPoint(x: -50, y: obstacleHeight + 50), duration: 5)
            
            obstacle.run(moveObstacle)
            obstacleTwo.run(moveObstacleTwo)
        }
        
        let sequence = SKAction.sequence([spawnObstacles, timer])
        self.run(SKAction.repeatForever(sequence), withKey: obstacleKey)
        
        
    }
    
    func obstacleHeight() -> CGFloat {
        let height = Int.random(in: 100...Int(frame.height))
        return CGFloat(height)
    }
    
    func gameOver() {
        scene?.removeAllChildren()
        
        player.removeFromParent()
        gameOverText = SKLabelNode(fontNamed: "Chalkduster")
        gameOverText.text = "GAME OVER"
        gameOverText.fontColor = .red
        gameOverText.fontSize = 30
        gameOverText.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(gameOverText)
        
        spawnScoreLabel(position: CGPoint(x: frame.midX, y: frame.midY - 50))
        
        obstacle.removeFromParent()
        obstacleTwo.removeFromParent()
        removeAction(forKey: obstacleKey)
        isGameOver = true
        isGameStarted = false
        print("game over")
        print("game over =\(isGameOver)")
        print("is game started= \(isGameStarted)")
        spawnGround()
    }
    
    func beginButton() {
        startButton = SKLabelNode(fontNamed: "Chalkduster")
        startButton.text = "Start"
        startButton.fontColor = .yellow
        startButton.fontSize = 30
        startButton.position = CGPoint(x: frame.midX, y: frame.maxY)
        self.addChild(startButton)
    }
    
    func resetGame() {
        //let timer = SKAction.wait(forDuration: 1)
        //let spawn = SKAction.run{ [self] in
        
        spawnPlayer()
        beginButton()
        gameOverText.removeFromParent()
        isGameOver = false
        isGameStarted = false
        
        print("reset")
        print("game over =\(isGameOver)")
        print("is game started= \(isGameStarted)")
            
        //}
        //let sequence = SKAction.sequence([timer, spawn])
        //self.run(sequence)
        
    }
    
    func spawnBackground() {
        background = SKSpriteNode(texture: SKTexture(imageNamed: "background"), size: CGSize(width: CGFloat(displaySize.width), height: CGFloat(displaySize.height)))
        background.position = CGPoint(x: 0, y: (displaySize.midY))
        
        
        addChild(background)
    }
    
    func spawnLeftPoint() {
        
        leftPoint = SKSpriteNode(color: .clear, size: CGSize(width: 5, height: 20))
        leftPoint.position = CGPoint(x: 100, y: frame.minY+50)
        leftPoint.name = "leftPoint"
        leftPoint.physicsBody = SKPhysicsBody(rectangleOf: leftPoint.size)
        leftPoint.physicsBody?.categoryBitMask = 1
        leftPoint.physicsBody?.contactTestBitMask = 1
        leftPoint.physicsBody?.affectedByGravity = false
        addChild(leftPoint)
        
    }
    
    func spawnScoreLabel(position: CGPoint) {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "\(playerScore)"
        scoreLabel.fontColor = .yellow
        scoreLabel.fontSize = 50
        scoreLabel.position = position
        addChild(scoreLabel)
    }
    
    
}
