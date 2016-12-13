//
//  MovingCar.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/24/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//


import SpriteKit
import GameplayKit

class MovingCar: SKSpriteNode, ObstacleCreate{
    
    var textureAtlas:SKTextureAtlas!
    var textureArray = [SKTexture]()
    var dir:String!
    var startPos:CGPoint!
    var endPos:CGPoint!
    
    init(size: CGSize, duration:TimeInterval){
        // Choose a car
        var possibleCars = ["taxi","truck","sedan"]
        possibleCars = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleCars) as! [String]
        
        super.init(texture: SKTexture(imageNamed: "\(possibleCars[0])"), color: UIColor.clear , size: CGSize(width: 125/2, height: 125))
        let rand1 = arc4random_uniform(2)
        if rand1 == 0{
            dir = "left"
            startPos = CGPoint(x: 0.3375 * size.width/2, y: size.height/2 + self.size.height/2)
            endPos = CGPoint(x: 0.2 * size.width/2, y: -1 * (size.height/2 + self.size.height/2))
        } else{
            dir = "right"
            startPos = CGPoint(x: 0.2 * size.width/2, y: size.height/2 + self.size.height/2)
            endPos = CGPoint(x: 0.3375 * size.width/2, y: -1 * (size.height/2 + self.size.height/2))
        }
        
        textureAtlas = SKTextureAtlas(named: "\(possibleCars[0])_\(dir!)")
        
        
        for i in 0..<textureAtlas.textureNames.count{
            let name = "\(possibleCars[0])_\(dir!)_\(i)"
            textureArray.append(SKTexture(imageNamed: name))
        }
        
        self.zPosition = 1
        self.name = "movingCar"
        initPhysicsBody()
        generatePosition(size)
        begin(size, duration)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generatePosition(_ size:CGSize){

        self.position = startPos
        
    }
    
    
    func initPhysicsBody() {
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
        
    }
    
    func begin(_ size: CGSize, _ dur: TimeInterval) {
        var group:SKAction
        let flash = SKAction.repeat(SKAction.animate(with: textureArray, timePerFrame: 0.4), count: 5)
        let moveAction = SKAction.move(to: endPos, duration: dur)
        /*
        if preferences.bool(forKey: "sfx") == true {
            let siren = SKAction.playSoundFileNamed("ambulance_s.mp3", waitForCompletion: false)
            group = SKAction.group([flash,moveAction,siren])
        }else{
            group = SKAction.group([flash,moveAction])
        }
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([group,removeAction]))*/
        group = SKAction.group([flash,moveAction])
        self.run(SKAction.sequence([group,removeNodeAction]))
    }
    
    
}
