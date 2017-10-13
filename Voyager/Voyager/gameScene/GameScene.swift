//
//  GameScene.swift
//  Voyager
//
//  Created by Cesar Carrillo on 10/6/17.
//  Copyright © 2017 Cesar Carrillo. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class SharedData {
    static let data = SharedData()
    var highScoreCheck: Int = 0
}



class GameScene: SKScene,SKPhysicsContactDelegate {
    
   let sharedData = SharedData.data
    
    
    
    var player:SKSpriteNode?
    var enemy:SKSpriteNode?
    var enemy2:SKSpriteNode?
    var enemy3:SKSpriteNode?
    
    var item:SKSpriteNode?
    var brownBig:SKSpriteNode?
    var brownSmall:SKSpriteNode?
    var silverBig:SKSpriteNode?
    var silverSmall:SKSpriteNode?
    //score
    var scoreLabel:SKLabelNode?
    //stars
    var spawnStarBoy:TimeInterval = 1.5
    var timeSinceStar:TimeInterval = 0
    var lastTimeStar:TimeInterval = 0
    //asteroids
    var spawnAsteroids:TimeInterval = 2.5
    var timeSinceAsteroid:TimeInterval = 0
    var lastTimeAsteroid:TimeInterval = 0
    //enemies
    var spawnEnemy:TimeInterval = 2
    var timeSinceEnemy:TimeInterval = 0
    var lastTimeEnemy:TimeInterval = 0
    //laser
    var fireRate:TimeInterval = 0.5
    var timeSinceFire:TimeInterval = 0
    var lastTime:TimeInterval = 0
    
    static var newScore:Int = 0
    static var oldScore:Int = 0
    var crash:Int = 1
    
    let noCategory:UInt32 = 0
    let laserCategory:UInt32 = 0b1
    let playerCategory:UInt32 = 0b1 << 1
    let enemyCategory:UInt32 = 0b1 << 2
    let itemCategory:UInt32 = 0b1 << 3
    let asteroitdCategory:UInt32 = 0b1 << 4
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        
        player = self.childNode(withName: "player") as? SKSpriteNode
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = noCategory
        player?.physicsBody?.contactTestBitMask = enemyCategory | itemCategory
        
        item = self.childNode(withName: "starScore") as? SKSpriteNode
        item?.physicsBody?.categoryBitMask = itemCategory
        item?.physicsBody?.collisionBitMask = noCategory
        item?.physicsBody?.contactTestBitMask = playerCategory
        
        enemy = self.childNode(withName: "enemy1") as? SKSpriteNode
        enemy?.physicsBody?.categoryBitMask = enemyCategory
        enemy?.physicsBody?.collisionBitMask = noCategory
        enemy?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
        enemy2 = self.childNode(withName: "enemy2") as? SKSpriteNode
        enemy2?.physicsBody?.categoryBitMask = enemyCategory
        enemy2?.physicsBody?.collisionBitMask = noCategory
        enemy2?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
        enemy3 = self.childNode(withName: "enemy3") as? SKSpriteNode
        enemy3?.physicsBody?.categoryBitMask = enemyCategory
        enemy3?.physicsBody?.collisionBitMask = noCategory
        enemy3?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
        brownSmall = self.childNode(withName: "brownSmall") as? SKSpriteNode
        brownSmall?.physicsBody?.categoryBitMask = asteroitdCategory
        brownSmall?.physicsBody?.collisionBitMask = noCategory
        brownSmall?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
       
        brownBig = self.childNode(withName: "brownBig") as? SKSpriteNode
        brownBig?.physicsBody?.categoryBitMask = asteroitdCategory
        brownBig?.physicsBody?.collisionBitMask = noCategory
        brownBig?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
        silverBig = self.childNode(withName: "silverBig") as? SKSpriteNode
        silverBig?.physicsBody?.categoryBitMask = asteroitdCategory
        silverBig?.physicsBody?.collisionBitMask = noCategory
        silverBig?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
        silverSmall = self.childNode(withName: "silverSmall") as? SKSpriteNode
        silverSmall?.physicsBody?.categoryBitMask = asteroitdCategory
        silverSmall?.physicsBody?.collisionBitMask = noCategory
        silverSmall?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
        
        GameScene.oldScore = GameScene.newScore
        GameScene.newScore = 0
        
        do{
            let sounds:[String] = ["explosion","laser"]
            for sound in sounds{
                let path:String = Bundle.main.path(forResource: sound, ofType: "wav")!
                let url:URL = URL(fileURLWithPath: path)
                let player:AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
            }
        }catch{
            
        }
        
        let backGroundMusic:SKAudioNode = SKAudioNode(fileNamed: "music.m4a")
        backGroundMusic.autoplayLooped = true
        self.addChild(backGroundMusic)
        
        
      //  creating animation through code
       let moveLeft:SKAction = SKAction.moveBy(x: -200, y: 0, duration: 1)
       moveLeft.timingMode = .linear
       let reversedAction:SKAction = moveLeft.reversed()
       let sequence:SKAction = SKAction.sequence([moveLeft,reversedAction,reversedAction,moveLeft])
       let repeatAction:SKAction = SKAction.repeatForever(sequence)
       item?.run(repeatAction)
        

     
        
        let afterBurner:SKEmitterNode = SKEmitterNode(fileNamed: "afterBurner")!
        player?.addChild(afterBurner)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let cA:UInt32 = contact.bodyA.categoryBitMask
        let cB:UInt32 = contact.bodyB.categoryBitMask
        
        if cA == playerCategory || cB == playerCategory {
            let otherNode:SKNode = (cA == playerCategory) ? contact.bodyB.node! : contact.bodyA.node!
            playerDidCollide(with: otherNode)
        }
        else {
            let explosion:SKEmitterNode = SKEmitterNode(fileNamed: "Explosion")!
            explosion.position = contact.bodyA.node!.position
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("explosion", waitForCompletion: false))
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
        
        
    }
    
    
    func playerDidCollide(with other:SKNode) {
        if other.parent == nil {
            return
        }
        
        let otherCategory = other.physicsBody?.categoryBitMask
        if otherCategory == itemCategory {
            let points:Int = other.userData?.value(forKey: "points") as! Int
            GameScene.newScore += points
            scoreLabel?.text = "Score: \(GameScene.newScore)"
            
            other.removeFromParent()
            
        }
        else if otherCategory == enemyCategory || otherCategory == asteroitdCategory {
            
            let explosion:SKEmitterNode = SKEmitterNode(fileNamed: "Explosion")!
            explosion.position = player!.position
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("explosion", waitForCompletion: false))
            
            print("-------\(GameScene.oldScore)------\(GameScene.newScore)--------")
            if GameScene.oldScore > GameScene.newScore {
                sharedData.highScoreCheck = GameScene.oldScore
            }else if GameScene.newScore > GameScene.oldScore{
                sharedData.highScoreCheck = GameScene.newScore
            }
            
            other.removeFromParent()
            player?.removeFromParent()
            crash = 0
            print("crash")
        }
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        player?.position = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        player?.position = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        player?.position = pos
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        checkLaser(currentTime - lastTime)
        checkEnemy(currentTime - lastTimeEnemy)
        checkAsteroid(currentTime - lastTimeAsteroid)
        checkStars(currentTime - lastTimeStar)
        
        lastTime = currentTime
        lastTimeEnemy = currentTime
        lastTimeAsteroid = currentTime
        lastTimeStar = currentTime
        
    }
    
    func checkLaser(_ frameRate:TimeInterval) {
        // add time to timer
        timeSinceFire += frameRate
        
        // return if it hasn't been enough time to fire laser
        if timeSinceFire < fireRate {
            return
        }
        
        //spawn laser
        if crash == 1 {
            spawnLaser()
        }
        
        
        
        // reset timer
        timeSinceFire = 0
    }

    func spawnLaser() {
        
        let scene:SKScene = SKScene(fileNamed: "Laser")!
        

        
        
        if GameScene.newScore > 100{
            fireRate = 0.2
            
            let laser = scene.childNode(withName: "laserRed")
            laser?.position = player!.position
            laser?.move(toParent: self)
            laser?.physicsBody?.categoryBitMask = laserCategory
            laser?.physicsBody?.collisionBitMask = noCategory
            laser?.physicsBody?.contactTestBitMask = enemyCategory | asteroitdCategory
            
            player?.color = .red
            player?.colorBlendFactor = 0.5
            
            
            
            self.run(SKAction.playSoundFileNamed("laser", waitForCompletion: false))
        }
        else
        {
            let laser = scene.childNode(withName: "laserBlue")
            laser?.position = player!.position
            laser?.move(toParent: self)
            laser?.physicsBody?.categoryBitMask = laserCategory
            laser?.physicsBody?.collisionBitMask = noCategory
            laser?.physicsBody?.contactTestBitMask = enemyCategory | asteroitdCategory
            self.run(SKAction.playSoundFileNamed("laser", waitForCompletion: false))
            
        }
       
    }
    
    func checkEnemy(_ frameRate:TimeInterval) {
        // add time to timer
        timeSinceEnemy += frameRate
        
        // return if it hasn't been enough time to fire laser
        if timeSinceEnemy < spawnEnemy{
            return
        }
        
        //spawn laser
        if crash == 1 {
            spawnEnemies()
        }
        else if crash == 0{
            backToMenu()
        }
        
        
        
        // reset timer
        timeSinceEnemy = 0
    }
    func spawnEnemies()
    {
        let scene:SKScene = SKScene(fileNamed: "Enemy")!
        let Enemy = scene.childNode(withName: "enemy")
        Enemy?.position = enemy!.position
        Enemy?.move(toParent: self)
        Enemy?.physicsBody?.categoryBitMask = enemyCategory
        Enemy?.physicsBody?.collisionBitMask = noCategory
        Enemy?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
        let Enemy2 = scene.childNode(withName: "enemy2")
        Enemy2?.position = enemy2!.position
        Enemy2?.move(toParent: self)
        Enemy2?.physicsBody?.categoryBitMask = enemyCategory
        Enemy2?.physicsBody?.collisionBitMask = noCategory
        Enemy2?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
        let Enemy3 = scene.childNode(withName: "enemy3")
        Enemy3?.position = enemy3!.position
        Enemy3?.move(toParent: self)
        Enemy3?.physicsBody?.categoryBitMask = enemyCategory
        Enemy3?.physicsBody?.collisionBitMask = noCategory
        Enemy3?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
    }
    
    
    func checkAsteroid(_ frameRate:TimeInterval) {
        // add time to timer
        timeSinceAsteroid += frameRate
        
        // return if it hasn't been enough time to fire laser
        if timeSinceAsteroid < spawnAsteroids{
            return
        }
        
        //spawn laser
        if crash == 1 {
            spawnAsteroid()
        }
        
        
        
        // reset timer
        timeSinceAsteroid = 0
    }
    
    
    func spawnAsteroid(){
        
        let scene:SKScene = SKScene(fileNamed: "Asteroids")!
        
        let bSmall = scene.childNode(withName: "brownSmall")
        bSmall?.position = brownSmall!.position
        bSmall?.move(toParent: self)
        bSmall?.physicsBody?.categoryBitMask = asteroitdCategory
        bSmall?.physicsBody?.collisionBitMask = noCategory
        bSmall?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
        let bBig = scene.childNode(withName: "brownBig")
        bBig?.position = brownBig!.position
        bBig?.move(toParent: self)
        bBig?.physicsBody?.categoryBitMask = asteroitdCategory
        bBig?.physicsBody?.collisionBitMask = noCategory
        bBig?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
        let sSmall = scene.childNode(withName: "silverSmall")
        sSmall?.position = silverSmall!.position
        sSmall?.move(toParent: self)
        sSmall?.physicsBody?.categoryBitMask = asteroitdCategory
        sSmall?.physicsBody?.collisionBitMask = noCategory
        sSmall?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
        let sBig = scene.childNode(withName: "silverBig")
        sBig?.position = silverBig!.position
        sBig?.move(toParent: self)
        sBig?.physicsBody?.categoryBitMask = asteroitdCategory
        sBig?.physicsBody?.collisionBitMask = noCategory
        sBig?.physicsBody?.contactTestBitMask = playerCategory | laserCategory
        
    }
    
    func checkStars(_ frameRate:TimeInterval) {
        // add time to timer
        timeSinceStar += frameRate
        
        // return if it hasn't been enough time to fire laser
        if timeSinceStar < spawnStarBoy{
            return
        }
        
    
            spawnStars()
        
        
        
        
        // reset timer
        timeSinceStar = 0
    }
    func spawnStars(){
        let scene:SKScene = SKScene(fileNamed: "Stars")!
        let starBoy = scene.childNode(withName: "starBoi")
        starBoy?.position = item!.position
        starBoy?.move(toParent: self)
        starBoy?.physicsBody?.categoryBitMask = itemCategory
        starBoy?.physicsBody?.collisionBitMask = noCategory
        starBoy?.physicsBody?.contactTestBitMask = playerCategory
        print("Star gen")
    }
    
    
    func backToMenu(){
       
            if let view = self.view {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "mainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
                }
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
    

}

