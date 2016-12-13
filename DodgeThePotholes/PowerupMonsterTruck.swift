//
//  OneUp.swift
//  DodgeThePotholes
//
//  Created by Peter Murphy on 12/2/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit

class PowerupMosterTruck: SKSpriteNode {
    
    var wrapTimer:Int = 15
    var gameSK:GameScene!
    
    init(scene: GameScene, duration:TimeInterval){
        gameSK = scene
        super.init(texture: SKTexture(imageNamed:"star"), color: UIColor.clear, size: CGSize(width :monstertruck.width.rawValue, height:monstertruck.height.rawValue))
        self.name = "star"
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
        self.physicsBody?.categoryBitMask = PhysicsCategory.Star.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    func begin(_ scene:GameScene, _ dur: TimeInterval){
        let moveAction = SKAction.moveTo(y: -scene.size.height/2 - self.size.height, duration: dur)
        self.run(SKAction.sequence([moveAction,removeNodeAction]))
    }
    
}
