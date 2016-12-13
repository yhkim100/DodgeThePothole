//
//  MultiplierPowerUp.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 12/1/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit

class MultiplierPowerUp: SKSpriteNode {
    
    var multTimer:Int = 30
    var gameSK:GameScene!
    var value:Int!
    
    init(scene: GameScene, duration:TimeInterval, val:Int){
        gameSK = scene
        value = val
        super.init(texture: SKTexture(imageNamed:"pow_x\(val)"), color: UIColor.clear, size: CGSize(width :50, height:50))
        self.name = "multiplier"
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
        //self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Multiplier.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
        
    }
    
    
    func begin(_ scene:GameScene, _ dur: TimeInterval){
        let moveAction = SKAction.moveTo(y: -scene.size.height/2 - self.size.height, duration: dur)
        self.run(SKAction.sequence([moveAction,removeNodeAction]))
    }
    
    func timerStart(_ scene:GameScene, _ dur: TimeInterval){
        var timer = Timer()
        var notifier:SKSpriteNode!
        powerUps.multiplier = value
        print("multiplier is \(value)")
        let show = SKAction.run {
            
            scene.timerLabel.isHidden = false
            print("pow_x\(self.value)")
            notifier = SKSpriteNode(imageNamed: "pow_x\(self.value!)")
            notifier.size = self.size
            notifier.position = scene.moneyLabel.position
            notifier.position.x = 0
            scene.addChild(notifier)
        }
        let countdown = SKAction.run {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                         selector: #selector(PowerupWrap.countdown),
                                         userInfo: nil,
                                         repeats: true)
            
            
        }
        let seconds = SKAction.wait(forDuration: TimeInterval(self.multTimer + 1))
        /*
         let flash = SKAction.sequence([
         SKAction.wait(forDuration: 10),
         SKAction.group([SKAction.wait(forDuration: 5),flashAction])
         ])
         */
        let hide = SKAction.run{
            scene.timerLabel.isHidden = true
            notifier.removeFromParent()
            powerUps.multiplier = 1
            timer.invalidate()
            print("multiplier is 1")
        }
        scene.run(SKAction.sequence([
            show,
            SKAction.group([seconds,countdown]),
            hide]))
    }
    
    func countdown(){
        gameSK.powerUpTime -= 1
    }
}
