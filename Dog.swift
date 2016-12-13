//
//  Dog.swift
//  DodgeThePotholes
//
//  Created by Peter Murphy on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class Dog: MoveableObstacle, ObstacleCreate {
    
    var textureAtlas = SKTextureAtlas(named: "German_Shepherd_Run")
    var textureArray = [SKTexture]()
    
    var orientation: CGFloat = 1
    
    init(size: CGSize, duration:TimeInterval){
        
        for i in 1...textureAtlas.textureNames.count{
            let name = "Shepherd_run_\(i)"
            textureArray.append(SKTexture(imageNamed: name))
        }
        
        super.init(texture: SKTexture(imageNamed:"Shepherd_default-1"), color: UIColor.clear, size: CGSize(width :dog.width.rawValue, height:dog.height.rawValue))
        self.name = "dog"
        generatePosition(size)
        initPhysicsBody()
        begin(size,duration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func generatePosition(_ size:CGSize){
        let rand = arc4random_uniform(2)
        if rand == 0{
            orientation = -1
        } else{
            orientation = 1
        }
        self.position = CGPoint(x: orientation*(size.width*0.375 + self.size.width/2), y: size.height/2 + self.size.height/2)
        self.xScale = fabs(self.xScale) * orientation
    }
    
    func initPhysicsBody(){
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.MoveableObstacle.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue | PhysicsCategory.Horn.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    override func destroy(){
        
        //self.texture = SKTexture(imageNamed:"German_Shepherd_Dead")
        self.physicsBody?.categoryBitMask = PhysicsCategory.None.rawValue
        
        var group:SKAction
        let die = SKAction.animate(with: [SKTexture(imageNamed:"German_Shepherd_Dead")], timePerFrame: 1)
        if preferences.bool(forKey: "sfx") == true {
            let wimper = SKAction.playSoundFileNamed("dog_wimper.mp3", waitForCompletion: false)
            group = SKAction.group([die,wimper])
        }else{
            group = die
        }
        
        self.run(group)
    }
    
    func begin(_ size:CGSize, _ dur: TimeInterval){
        
        let run = SKAction.repeat(SKAction.animate(with: textureArray, timePerFrame: 0.2), count: 5)
        let rand = GKRandomDistribution(lowestValue: 1,highestValue: 10).nextInt()
        let randFloat = CGFloat(rand)
        let runDir = SKAction.moveTo(x: orientation*(size.width/randFloat), duration: dur)
        let moveAction = SKAction.moveTo(y: -size.height /*- self.size.height */, duration: dur)
        
        
        let runGroup = SKAction.group([run,runDir,moveAction])
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([runGroup,removeAction]))
        
    }
    
    /*func begin(_ size:CGSize, _ dur: TimeInterval){
        
        let run = SKAction.repeat(SKAction.animate(with: textureArray, timePerFrame: 0.2), count: 5)
        let moveAction = SKAction.moveTo(y: -size.height - self.size.height, duration: dur)
        let runDir = SKAction.moveTo(x: 0, duration: dur*0.6)
        // Add barking sounds
        let runGroup = SKAction.group([run,runDir,moveAction])
        
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([runGroup,removeAction]))
        
    }*/
    
    override func runAway(_ Size:CGSize, _ dur: TimeInterval){
        self.xScale = -1*orientation
        let runAway = SKAction.repeat(SKAction.animate(with: textureArray, timePerFrame: 0.1), count: 10)
        let runDir = SKAction.moveTo(x:orientation*(Size.width/2 + self.size.width), duration: dur*0.25)
        let moveAction = SKAction.moveTo(y: -Size.height/2 - self.size.height, duration: dur/2)
        let runAction = SKAction.group([runAway,runDir,moveAction])
        self.run(SKAction.sequence([runAction,removeNodeAction]))

    }
}
