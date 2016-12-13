//
//  CarScene.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

/** This scene contains three car options to select from and
 a back button for returning to the Settings Scene. Some car 
 options may appear locked until the user purchases them in the shop
 */

import SpriteKit

class CarScene: SKScene, Alerts{
    
    var selectCarLabelNode: SKLabelNode!
    var redLockedLabelNode: SKLabelNode!
    var greenLockedLabelNode: SKLabelNode!
    
    var car1Node: SKSpriteNode!
    var car2Node: SKSpriteNode!
    var car3Node: SKSpriteNode!
    
    var car1SNode: SKSpriteNode!
    var car2SNode: SKSpriteNode!
    var car3SNode: SKSpriteNode!
    
    var backCarNode: SKSpriteNode!
    
    var currentCar: String!
    
    override func didMove(to view: SKView) {
        
        //Initializing Car Scene Labels and Nodes
        selectCarLabelNode = self.childNode(withName: "CarLabel") as! SKLabelNode!
        selectCarLabelNode.fontName = "PressStart2p"
        
        redLockedLabelNode = self.childNode(withName: "RedCarLocked") as! SKLabelNode!
        redLockedLabelNode.fontName = "PressStart2p"
        redLockedLabelNode.isHidden = preferences.value(forKey: "redcar") as! Bool!
        
        greenLockedLabelNode = self.childNode(withName: "GreenCarLocked") as! SKLabelNode!
        greenLockedLabelNode.fontName = "PressStart2p"
        greenLockedLabelNode.isHidden = preferences.value(forKey: "greencar") as! Bool!
        
        car1Node = self.childNode(withName: "Car1") as! SKSpriteNode!
        car2Node = self.childNode(withName: "Car2") as! SKSpriteNode!
        car3Node = self.childNode(withName: "Car3") as! SKSpriteNode!
        
        car1SNode = self.childNode(withName: "BlueCarSelected") as! SKSpriteNode!
        car2SNode = self.childNode(withName: "RedCarSelected") as! SKSpriteNode!
        car3SNode = self.childNode(withName: "GreenCarSelected") as! SKSpriteNode!
        updateSelectedCar()
        
        backCarNode = self.childNode(withName: "BackButton") as! SKSpriteNode!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            let transition = SKTransition.flipHorizontal(withDuration: 1.0)
            
            //Car one selected
            if nodesArray.first?.name == "Car1"{
                currentCar = "car1"
                preferences.setValue(currentCar, forKey: "car")
                preferences.synchronize()
            }
            //Car two selected
            else if nodesArray.first?.name == "Car2" || nodesArray.first?.name == "RedCarLocked" {
                if(preferences.value(forKey: "redcar") as! Bool){
                    currentCar = "car2"
                    preferences.setValue(currentCar, forKey: "car")
                    preferences.synchronize()
                }
                else{
                    //This item is not yet unlocked alert
                    notUnlocked()
                }
            }
            //Car three selected
            else if nodesArray.first?.name == "Car3" || nodesArray.first?.name == "GreenCarLocked"{
                if(preferences.value(forKey: "greencar") as! Bool){
                    currentCar = "car3"
                    preferences.setValue(currentCar, forKey: "car")
                    preferences.synchronize()
                }
                else{
                    //This item is not yet unlocked alert
                    notUnlocked()
                }
            }
            //Updates user selected car visually
            updateSelectedCar()
            //Returns the user to the settings scene
            if nodesArray.first?.name == "BackButton" {
                let settingsScene = SKScene(fileNamed: "SettingsScene")
                settingsScene?.scaleMode = .aspectFit
                self.view?.presentScene(settingsScene!, transition: transition)
            }
            
        }
    }
    
    func updateSelectedCar(){
        switch preferences.value(forKey: "car") as! String!{
        case "car1":
            car1SNode.isHidden = false
            car2SNode.isHidden = true
            car3SNode.isHidden = true
        case "car2":
            car1SNode.isHidden = true
            car2SNode.isHidden = false
            car3SNode.isHidden = true
        default:
            car1SNode.isHidden = true
            car2SNode.isHidden = true
            car3SNode.isHidden = false
            
        }
    }
    
}
