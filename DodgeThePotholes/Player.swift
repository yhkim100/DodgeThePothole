//
//  Player.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/10/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import AudioToolbox

class Player: SKSpriteNode, ObstacleCreate {
    
    var moveLeftTextureAtlas = SKTextureAtlas(named: "\(preferences.value(forKey: "car"))_Left")
    var moveLeftTextureArray = [SKTexture]()
    var moveRightTextureAtlas = SKTextureAtlas(named: "\(preferences.value(forKey: "car"))_Right")
    var moveRightTextureArray = [SKTexture]()
   // var monsterTruckTexture = [SKTexture]()
    
    init(size: CGSize){
        
        super.init(texture: SKTexture(imageNamed: preferences.value(forKey: "car") as! String), color: UIColor.clear, size: CGSize(width : player.width.rawValue, height:player.height.rawValue))
        generatePosition(size)
        initPhysicsBody()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func generatePosition(_ size:CGSize){
        self.position = CGPoint(x: 0, y: 3*self.size.height/2 - size.height/2)
        self.zPosition = 1
    }
    
    func initPhysicsBody(){
        self.physicsBody?.isDynamic = true
        //self.physicsBody = SKPhysicsBody(rectangleOf: self.size)

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: self.size.width/2, y:self.size.height/2),
                                CGPoint(x: -self.size.width/2, y:self.size.height/2),
                                CGPoint(x: -self.size.width/2, y:0),
                                CGPoint(x: self.size.width/2, y: 0)])
        path.closeSubpath()
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle.rawValue |
            PhysicsCategory.MoveableObstacle.rawValue |
            PhysicsCategory.Coin.rawValue |
            PhysicsCategory.Wrap.rawValue |
            PhysicsCategory.Multiplier.rawValue |
            PhysicsCategory.Star.rawValue |
            PhysicsCategory.OneUp.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    func begin(_ size:CGSize, _ dur: TimeInterval){
        //Do nothing
    }
    
    
    // MARK: Move Left and Move right = Stretch goals. will need to create group actions with the a tiny duration to see the blinker
    func moveRight(){
        let flash = SKAction.repeat(SKAction.animate(with: moveRightTextureArray, timePerFrame: 0.2), count: 2)
        self.run(flash)
    }
    
    func moveLeft(){
        let flash = SKAction.repeat(SKAction.animate(with: moveLeftTextureArray, timePerFrame: 0.2), count: 2)
        self.run(flash)
    }
    
    func spinOut(){
        let group:SKAction
        //let spin = SKAction.rotate(byAngle: 360, duration: 1)
        let spin = SKAction.rotate(toAngle: 4*3.14, duration: 0.75, shortestUnitArc: false)
        let reset = SKAction.setTexture(SKTexture(imageNamed: preferences.value(forKey: "car") as! String))
        if preferences.bool(forKey: "sfx") == true {
            let sound = SKAction.playSoundFileNamed("carskid.wav", waitForCompletion: true)
            group = SKAction.group([spin,sound])
        }else{
            group = spin
        }
        self.run(SKAction.sequence([group,reset]))
    }
    
    func recover(scene:GameScene){
        
        AudioServicesPlayAlertSound(UInt32(kSystemSoundID_Vibrate))
        
        let hide = SKAction.run {
            self.physicsBody?.categoryBitMask = PhysicsCategory.Recover.rawValue
            print("recover category bit mask")
        }
        let restore = SKAction.run {
            self.physicsBody?.categoryBitMask = PhysicsCategory.Car.rawValue
            scene.oneCollision = false
        }
        self.run(SKAction.sequence([hide,flashAction,restore]))
        
    }
    
    func becomeMonsterTruck(){
        self.physicsBody?.categoryBitMask = PhysicsCategory.MonsterTrucker.rawValue
        var monsterTruckTexture:SKAction
        self.alpha = 1
        //MonsterTruck
        if preferences.bool(forKey: "tank")  == true {
             monsterTruckTexture = SKAction.setTexture(SKTexture(imageNamed: "tank"))
        } else {
             monsterTruckTexture = SKAction.setTexture(SKTexture(imageNamed: "MonsterTruck"))
        }
        if preferences.bool(forKey: "music") == true {
            let scream = SKAction.playSoundFileNamed("RAMPAGE.mp3", waitForCompletion: true)
            let monsterTruckMusic = SKAction.playSoundFileNamed("monster_truck_jam.mp3", waitForCompletion: false)
            let soundGroup = SKAction.group([scream, monsterTruckMusic])
            self.run(SKAction.sequence([monsterTruckTexture,soundGroup]))
        } else {
            self.run(SKAction.sequence([monsterTruckTexture]))
        }
        
        self.size.height = monstertruck_player.height.rawValue
        self.size.width = monstertruck_player.width.rawValue
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: self.size.width/2, y:self.size.height/2),
                                CGPoint(x: -self.size.width/2, y:self.size.height/2),
                                CGPoint(x: -self.size.width/2, y:0),
                                CGPoint(x: self.size.width/2, y: 0)])
        path.closeSubpath()
        self.physicsBody?.categoryBitMask = PhysicsCategory.MonsterTrucker.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle.rawValue |
            PhysicsCategory.MoveableObstacle.rawValue |
            PhysicsCategory.Coin.rawValue |
            PhysicsCategory.Wrap.rawValue |
            PhysicsCategory.Multiplier.rawValue |
            PhysicsCategory.Star.rawValue |
            PhysicsCategory.OneUp.rawValue

        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        //self.physicsBody = SKPhysicsBody(polygonFrom: path)
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    func becomeCar(){
        self.size.height = monstertruck_player.height.rawValue
        self.size.width = monstertruck_player.width.rawValue
        let carTexture = SKAction.setTexture(SKTexture(imageNamed: preferences.value(forKey: "car") as! String))
        self.run(SKAction.sequence([carTexture]))
        self.alpha = 1
        self.size.height = player.height.rawValue
        self.size.width = player.width.rawValue
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: self.size.width/2, y:self.size.height/2),
                                CGPoint(x: -self.size.width/2, y:self.size.height/2),
                                CGPoint(x: -self.size.width/2, y:0),
                                CGPoint(x: self.size.width/2, y: 0)])
        path.closeSubpath()
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle.rawValue |
            PhysicsCategory.MoveableObstacle.rawValue |
            PhysicsCategory.Coin.rawValue |
            PhysicsCategory.Wrap.rawValue |
            PhysicsCategory.Multiplier.rawValue |
            PhysicsCategory.Star.rawValue |
            PhysicsCategory.OneUp.rawValue

        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    

}
