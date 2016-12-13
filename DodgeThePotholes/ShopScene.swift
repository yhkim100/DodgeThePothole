//
//  ShopScene.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 12/3/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//
/** This scene contains all the items that can be purchased using
    the money earned in the game. The user's money is displayed on 
    screen as well as the cost of each of the items below the items.
    If an item has been purchased, an alert saying so will appear 
    when the user tries to buy it.
 
*/

import SpriteKit


class ShopScene: SKScene, Alerts{
    
    //Shop Scene Labels
    var shopLabelNode:SKLabelNode!
    var moneyLabelNode:SKLabelNode!
    var lifeCostLabelNode:SKLabelNode!
    var carCostLabelNode:SKLabelNode!
    var tankCostLabelNode:SKLabelNode!
    var songCostLabelNode:SKLabelNode!
    
    
    //Shop Scene Buttons
    var buyNewCar:SKSpriteNode!
    var carBackground:SKSpriteNode!
    var buyLife:SKSpriteNode!
    var lifeBackground:SKSpriteNode!
    var buyTank:SKSpriteNode!
    var tankBackground:SKSpriteNode!
    var buySong:SKSpriteNode!
    var backButton:SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        
        //Intinializing Scene Labels
        shopLabelNode = self.childNode(withName: "ShopLabel") as! SKLabelNode!
        shopLabelNode.fontName = "PressStart2p"
        shopLabelNode.text = "Shop"
        
        moneyLabelNode = self.childNode(withName: "MoneyLabel") as! SKLabelNode!
        moneyLabelNode.fontName = "PressStart2p"
        moneyLabelNode.text = "Money: $ \(preferences.value(forKey: "money")!)"
        
        carCostLabelNode = self.childNode(withName: "CarCost") as! SKLabelNode!
        carCostLabelNode.fontName = "PressStart2p"
        carCostLabelNode.text = " $ \(carCost)"
        
        
        lifeCostLabelNode = self.childNode(withName: "LifeCost") as! SKLabelNode!
        lifeCostLabelNode.fontName = "PressStart2p"
        lifeCostLabelNode.text = " $ \(lifeCost)"
        
        tankCostLabelNode = self.childNode(withName: "TankCost") as! SKLabelNode!
        tankCostLabelNode.fontName = "PressStart2p"
        tankCostLabelNode.text = " $ \(tankCost)"
        
        songCostLabelNode = self.childNode(withName: "SongCost") as! SKLabelNode!
        songCostLabelNode.fontName = "PressStart2p"
        songCostLabelNode.text = " $ \(songCost)"
        
        backButton = self.childNode(withName: "BackButton") as! SKSpriteNode!
        
        buyNewCar = self.childNode(withName: "PurchaseCar") as! SKSpriteNode!
        updateCarTexture()
        carBackground = self.childNode(withName: "CarBackground") as! SKSpriteNode!
        
        buyLife = self.childNode(withName: "PurchaseLife") as! SKSpriteNode!
        lifeBackground = self.childNode(withName: "LifeBackground") as! SKSpriteNode!
        
        buyTank = self.childNode(withName: "PurchaseTank") as! SKSpriteNode!
        tankBackground = self.childNode(withName: "TankBackground") as! SKSpriteNode!
        
        buySong = self.childNode(withName: "PurchaseCar") as! SKSpriteNode!
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            let transition = SKTransition.flipHorizontal(withDuration: 1.0)
            
            if nodesArray.first?.name == "BackButton"{
                let menuScene = SKScene(fileNamed: "MenuScene")
                menuScene?.scaleMode = .aspectFit
                self.view?.presentScene(menuScene!, transition: transition)
            }
            else if nodesArray.first?.name == "PurchaseCar" || nodesArray.first?.name == "CarBackground" {
                if(carCost > preferences.value(forKey: "money") as! Int){
                    //insufficient funds: Call insufficient funds alert
                    insufficientFunds(title: "Insufficient Funds!!!", message: "This item costs $\(carCost)")
                }
                else{
                    var car = String()
                    if(preferences.value(forKey: "redcar") as! Bool == false){
                        car = "redcar"
                    }
                    else{
                        car = "greencar"
                    }
                    if(preferences.value(forKey: car) as! Bool == false){
                        doPurchase(title: "Purchase Car", message: "Do you want to buy this car?", cost: carCost, item: car)
                        updateCarTexture()
                    }
                    else{
                        //already purchased alert
                        alreadyPurchased()
                    }
                }
            }
            else if nodesArray.first?.name == "PurchaseLife" || nodesArray.first?.name == "LifeBackground"{
                if(lifeCost > preferences.value(forKey: "money") as! Int){
                    //insufficient funds: Call insufficient funds alert
                    insufficientFunds(title: "Insufficient Funds!!!", message: "This item costs $\(lifeCost)")
                }
                else{
                    if(preferences.value(forKey: "life") as! Bool == false){
                        doPurchase(title: "Purchase Extra Life", message: "Do you want to purchase an extra life?", cost: lifeCost, item: "life")
                    }
                    else{
                        //already purchased alert
                        alreadyPurchased()
                    }
                }
            }
            //User is trying to purchase a tank
            else if nodesArray.first?.name == "PurchaseTank" || nodesArray.first?.name == "TankBackground"{
                if(tankCost > preferences.value(forKey: "money") as! Int){
                    insufficientFunds(title: "Insufficient Funds!!!", message: "This item costs $\(tankCost)")
                }
                else{
                    if(preferences.value(forKey: "tank") as! Bool == false){
                        doPurchase(title: "Purchase Tank", message: "Do you want to purchase a tank to replace the monster truck?", cost: tankCost, item: "tank")
                    }
                    else{
                        //already purchased alert
                        alreadyPurchased()
                    }
                }
            }
            
            //User is trying to purchase a song
            else if nodesArray.first?.name == "PurchaseSong"{
                if songCost > preferences.value(forKey: "money") as! Int{
                    insufficientFunds(title: "Insufficient Funds!!!", message: "This item costs $\(songCost)")
                }
                else{
                    let songList = preferences.dictionary(forKey: "songs") as! Dictionary<String, Bool>
                    var songsArray = Array<String>()
                    for (key,value) in songList{
                        if value == true {
                            songsArray.append(key)
                        }
                    }
                    //If there are songs that haven't been purchased, purchase the one that hasn't been purchased.
                    if songsArray.count != songList.count{
                        for (key, _) in songList{
                            if let songPresent = songList[key]! as Bool!{
                                if songPresent == false{
                                    let songName = key.components(separatedBy: ".")
                                    doPurchase(title: "Purchase Song", message: "Do you want to purchase the \(songName[0]) song for use in-game?", cost: songCost, item: "song", itemName: key)
                                    break
                                }
                            }
                        }
                    }
                    //If all songs have been purchased, display an alert
                    else{
                        alreadyPurchased()
                    }
                }
            }
        }
        
    }
    
    //Updates user's money shown as items are purchased
    override func update(_ currentTime: TimeInterval) {
        moneyLabelNode.text = "Money: $ \(preferences.value(forKey: "money")!)"
    }
    
    //Updates the car texture to reflect the car being purchased
    func updateCarTexture(){
        if(preferences.value(forKey: "redcar") as! Bool == false){
            buyNewCar.texture = SKTexture(imageNamed: "car2")
        }
        else{
            buyNewCar.texture = SKTexture(imageNamed: "car3")
        }
    }
    
}
