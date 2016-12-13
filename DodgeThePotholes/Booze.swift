//
//  Booze.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 12/5/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit

class Booze: SKSpriteNode {
    
    var boozeTimer:Int = 15
    var gameSK:GameScene!
    
    init(scene: GameScene, duration:TimeInterval){
        gameSK = scene
        super.init(texture: SKTexture(imageNamed:"beer"), color: UIColor.clear, size: CGSize(width :30, height:60))
        self.name = "beer"
        generatePosition(scene.size)
        initPhysicsBody()
        begin(scene,duration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func generatePosition(_ size:CGSize){
        let rand = GKRandomDistribution(lowestValue: Int(-size.width/2) + Int(self.size.width/2),highestValue: Int(size.width/2) - Int(self.size.width/2))
        self.position = CGPoint(x:CGFloat(rand.nextInt()),y:size.height/2 + self.size.height/2)
    }
    
    func initPhysicsBody(){
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Booze.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
        
    }
    
    
    func begin(_ scene:GameScene, _ dur: TimeInterval){
        let moveAction = SKAction.moveTo(y: -scene.size.height/2 - self.size.height, duration: dur)
        self.run(SKAction.sequence([moveAction,removeNodeAction]))
    }
    
    func timerStart(_ scene:GameScene, _ dur: TimeInterval){
        
        scene.drinkingGoggles.size = scene.size
        scene.drinkingGoggles.color = SKColor.black
        scene.drinkingGoggles.position = CGPoint(x:0,y:0)
        scene.drinkingGoggles.alpha = 0.3
        scene.drinkingGoggles.zPosition = 3
        let fadeDark = SKAction.fadeAlpha(to: 1, duration: 1)
        let fadeLight = SKAction.fadeAlpha(to: 0.3, duration: 1)
        let fader = SKAction.repeat(SKAction.sequence([fadeDark,fadeLight]), count: Int(boozeTimer/2))
        //let faderAction = SKAction.sequence([fader,removeNodeAction])
        scene.addChild(scene.drinkingGoggles)
        
        
        let seconds = SKAction.wait(forDuration: TimeInterval(self.boozeTimer))
        let start = SKAction.run{
            scene.drunkDriving = true
            print("drunk driver!")
        }
        /*
        let fadeLayer = SKAction.run{
            scene.drinkingGoggles.run(fader)
        }*/
        scene.drinkingGoggles.run(SKAction.sequence([fader,removeNodeAction]))
        let audioTweak = SKAction.changePlaybackRate(to: 0.5, duration: 2)
        scene.bgAudio.run(audioTweak)

        let hide = SKAction.run{
            scene.drunkDriving = false
            scene.bgAudio.run(SKAction.changePlaybackRate(to: 1, duration: 1))
            //scene.drinkingGoggles.removeFromParent()
            print("no longer drunk driving")
        }
        scene.run(SKAction.sequence([
            start,
            seconds,
            hide]))
    }

    
}
