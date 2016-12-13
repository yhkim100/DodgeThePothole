//
//  MoveableObstacle.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/10/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit

class MoveableObstacle: SKSpriteNode {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize){
    
        super.init(texture: texture, color: color, size: size)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func destroy(){
        
    }
    
    func runAway(_ Size: CGSize, _ dur: TimeInterval){
        
    }
}
