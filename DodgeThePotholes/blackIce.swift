//
//  Potholes.swift
//  DodgeThePotholes
//
//  Created by Peter Murphy on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit

class blackIce: SKSpriteNode, ObstacleCreate {
    
    var possibleIce = ["ice"]
    
    
    init(size: CGSize, duration:TimeInterval){
        
        
        possibleIce = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleIce) as! [String]
        super.init(texture: SKTexture(imageNamed:possibleIce[0]), color: UIColor.clear, size: CGSize(width :ice.width.rawValue, height:ice.height.rawValue))
        
        
        self.name = "ice"
        generatePosition(size)
        initPhysicsBody()
        begin(size,duration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func generatePosition(_ size:CGSize){
        let rand = GKRandomDistribution(lowestValue: Int(size.width*ice.low.rawValue) + Int(self.size.width/2),highestValue: Int(size.width*ice.high.rawValue) - Int(self.size.width/2))
        self.position = CGPoint(x:CGFloat(rand.nextInt()),y:size.height/2 + self.size.height/2)
    }
    
    func initPhysicsBody(){
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle.rawValue // of alien category
        self.physicsBody?.contactTestBitMask = PhysicsCategory.BlackIce.rawValue // object that collides with alien
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
        
    }
    
    
    func begin(_ size:CGSize, _ dur: TimeInterval){
        let moveAction = SKAction.moveTo(y: -size.height/2 - self.size.height, duration: dur)
        self.run(SKAction.sequence([moveAction,removeNodeAction]))
        
    }
}
