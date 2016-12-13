//
//  TrafficCone.swift
//  DodgeThePotholes
//
//  Created by Peter Murphy on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class Cone:SKSpriteNode {
    
    init(width:Int,height:Int){
        super.init(texture: SKTexture(imageNamed:"cone"), color: UIColor.clear, size: CGSize(width: width/2, height: height/2))
        self.name = "cone"
        initPhysicsBody()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func initPhysicsBody(){
        self.zPosition = 1
        self.physicsBody?.isDynamic = true
        //self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func begin(tileHeight:Int, row:Int, size:CGSize, pattern:CGSize, dur:TimeInterval){
        //let alert = SKSpriteNode(texture: SKTexture(imageNamed:"alert"))
        let y =  row * tileHeight + tileHeight/2
        let yPos = Int(-size.height/2) + Int(-pattern.height/2) - y
        let moveAction = SKAction.moveTo(y: CGFloat(yPos), duration: dur)
        self.run(SKAction.sequence([moveAction,removeNodeAction]))
    }
    
        
}
