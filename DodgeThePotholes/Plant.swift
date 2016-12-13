//
//  Potholes.swift
//  DodgeThePotholes
//
//  Created by Peter Murphy on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit

class Plant: SKSpriteNode, ObstacleCreate {
    
    var orientation: CGFloat = 1
    var possiblePlants = ["tree1","bush1"]
    var plantRow = [Int]()
    
    init(size: CGSize, duration:TimeInterval){
        
        possiblePlants = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possiblePlants) as! [String]
        super.init(texture: SKTexture(imageNamed:possiblePlants[0]), color: UIColor.clear, size: CGSize(width :plant.width.rawValue, height:plant.height.rawValue))
        self.name = "plant"
        
        //determine how many plants to make
        /*let rand = GKRandomDistribution(lowestValue: Int(plant.numPlantsMin.rawValue) ,
                                        highestValue: Int(plant.numplantsMax.rawValue))
        let numPlants = rand.nextInt()
        for i in 1...numPlants {
            plantRow.append(1)
            print("Creating \(i) plants")
        }*/
        
        
        generatePosition(size)
        initPhysicsBody()
        begin(size,duration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func generatePosition(_ size:CGSize){
        //let rand = GKRandomDistribution(lowestValue: Int(size.width*pothole.low.rawValue) + Int(self.size.width/2),highestValue: Int(size.width*pothole.high.rawValue) - Int(self.size.width/2))
        let rand = arc4random_uniform(2)
        if rand == 0{
            orientation = -1
        } else{
            orientation = 1
        }
        self.position = CGPoint(x:CGFloat(orientation*size.width*plant.low.rawValue),y:size.height/2 + self.size.height/2)
    }
    
    func initPhysicsBody(){
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
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
