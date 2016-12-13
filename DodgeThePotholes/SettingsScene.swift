//
//  SettingsScene.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

/** This scene has buttons leading to scenes for audio settings and car settings.
    It also contains a back button for returning to the Menu Scene.
 
*/

import SpriteKit


class SettingsScene: SKScene{

    var audioButtonNode:SKSpriteNode!
    var carButtonNode:SKSpriteNode!
    var backNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        //Initializing buttons as nodes
        audioButtonNode = self.childNode(withName: "AudioButton") as! SKSpriteNode!
        carButtonNode = self.childNode(withName: "CarButton") as! SKSpriteNode!
        backNode = self.childNode(withName: "BackButton") as! SKSpriteNode!
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            let transition = SKTransition.flipHorizontal(withDuration: 1.0)
            
            //AudioButton Pressed
            if nodesArray.first?.name == "AudioButton"{
                let audioScene = SKScene(fileNamed: "AudioScene")
                audioScene?.scaleMode = .aspectFit
                self.view?.presentScene(audioScene!, transition: transition)
            }
            //CarButton Pressed
            else if nodesArray.first?.name == "CarButton" {
                let carScene = SKScene(fileNamed: "CarScene")
                carScene?.scaleMode = .aspectFit
                self.view?.presentScene(carScene!, transition: transition)
            }
            //BackButton Pressed
            else if nodesArray.first?.name == "BackButton"{
                let menuScene = SKScene(fileNamed: "MenuScene")
                menuScene?.scaleMode = .aspectFit
                self.view?.presentScene(menuScene!, transition: transition)
            }
        }
    }
}
