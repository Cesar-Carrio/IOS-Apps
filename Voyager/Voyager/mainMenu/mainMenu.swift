//
//  mainMenu.swift
//  Voyager
//
//  Created by Cesar Carrillo on 10/6/17.
//  Copyright © 2017 Cesar Carrillo. All rights reserved.
//

import SpriteKit
import GameKit



class mainMenu: SKScene,SKPhysicsContactDelegate {
    
    let newScore = SharedData.data
    
    
    var highestScoreLabel:SKLabelNode?
    
    override func didMove(to view: SKView) {
       self.physicsWorld.contactDelegate = self
        
      
        highestScoreLabel = self.childNode(withName: "highScore") as? SKLabelNode
    
        let leader:SKSpriteNode = self.childNode(withName: "leader") as! SKSpriteNode
        let drone1:SKSpriteNode = leader.childNode(withName: "drone1") as! SKSpriteNode
        let drone2:SKSpriteNode = leader.childNode(withName: "drone2") as! SKSpriteNode
        
        let afterBurner:SKEmitterNode = SKEmitterNode(fileNamed: "afterBurner")!
        self.physicsWorld.contactDelegate = leader as? SKPhysicsContactDelegate
        
        let changeColors: [SKSpriteNode] = [leader,drone1,drone2]
        for color in changeColors{
            color.color = .cyan
            color.colorBlendFactor = 0.5
        }
        
        leader.addChild(afterBurner)
        
        
        let backGroundMusic:SKAudioNode = SKAudioNode(fileNamed: "music.m4a")
        backGroundMusic.autoplayLooped = true
        self.addChild(backGroundMusic)
        
        
       
        
        highestScoreLabel?.text = "High Score: \(newScore.highScoreCheck)"
        print(newScore.highScoreCheck)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
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
