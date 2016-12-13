//
//  TextMessage.swift
//  DodgeThePotholes
//
//  Created by Peter Murphy on 12/4/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//


import SpriteKit
import GameplayKit

class TextMessage: SKSpriteNode, ObstacleCreate {
    
    init(size: CGSize, duration:TimeInterval){
        //let phone = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possiblePotholes) as! [String]
        super.init(texture: SKTexture(imageNamed:"phone"), color: UIColor.clear, size: CGSize(width :phone.width.rawValue, height:phone.height.rawValue))
        self.name = "phone"
        generatePosition(size)
        initPhysicsBody()
        begin(size,duration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generatePosition(_ size:CGSize){
        let rand = GKRandomDistribution(lowestValue: Int(size.width*phone.low.rawValue) + Int(self.size.width/2),highestValue: Int(size.width*phone.high.rawValue) - Int(self.size.width/2))
        self.position = CGPoint(x:CGFloat(rand.nextInt()),y:size.height/2 + self.size.height/2)
    }
    
    func initPhysicsBody(){
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: phone.width.rawValue/2, height: phone.height.rawValue))
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle.rawValue // of alien category
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue // object that collides with alien
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func begin(_ size:CGSize, _ dur: TimeInterval){
        let moveAction = SKAction.moveTo(y: -size.height/2 - self.size.height, duration: dur)
        self.run(SKAction.sequence([moveAction,removeNodeAction]))
        
    }
}
