//
//  Highscores.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 11/20/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//
/** This scene displays both a local highscore as well as a leaderboard
    showing the top ten scores reached in the game by all users. If the 
    user's score is in the top ten, it is displayed in yellow text.
 
 */

import SpriteKit
import FirebaseDatabase


class Highscore: SKScene {
    
    //Highscore Labels
    var highscoreTitleLabelNode:SKLabelNode!
    var leaderboardTitleLabelNode:SKLabelNode!
    var highscoreLabelNode:SKLabelNode!
    
    var firstLabel:SKLabelNode!
    var secondLabel:SKLabelNode!
    var thirdLabel:SKLabelNode!
    var fourthLabel:SKLabelNode!
    var fifthLabel:SKLabelNode!
    var sixthLabel:SKLabelNode!
    var seventhLabel:SKLabelNode!
    var eighthLabel:SKLabelNode!
    var ninethLabel:SKLabelNode!
    var tenthLabel:SKLabelNode!
    
    //Back Button
    var backNode:SKSpriteNode!

    
    override func didMove(to view: SKView) {
        
        //Initializing Labels
        highscoreTitleLabelNode = self.childNode(withName: "highscoreTitleLabel") as! SKLabelNode!
        highscoreTitleLabelNode.fontName = "PressStart2p"
        
        leaderboardTitleLabelNode = self.childNode(withName: "Leaderboard") as! SKLabelNode!
        leaderboardTitleLabelNode.fontName = "PressStart2p"
        
        firstLabel = self.childNode(withName: "first") as! SKLabelNode!
        firstLabel.fontName = "PressStart2p"
        secondLabel = self.childNode(withName: "second") as! SKLabelNode!
        secondLabel.fontName = "PressStart2p"
        thirdLabel = self.childNode(withName: "third") as! SKLabelNode!
        thirdLabel.fontName = "PressStart2p"
        fourthLabel = self.childNode(withName: "fourth") as! SKLabelNode!
        fourthLabel.fontName = "PressStart2p"
        fifthLabel = self.childNode(withName: "fifth") as! SKLabelNode!
        fifthLabel.fontName = "PressStart2p"
        sixthLabel = self.childNode(withName: "sixth") as! SKLabelNode!
        sixthLabel.fontName = "PressStart2p"
        seventhLabel = self.childNode(withName: "seventh") as! SKLabelNode!
        seventhLabel.fontName = "PressStart2p"
        eighthLabel = self.childNode(withName: "eighth") as! SKLabelNode!
        eighthLabel.fontName = "PressStart2p"
        ninethLabel = self.childNode(withName: "nineth") as! SKLabelNode!
        ninethLabel.fontName = "PressStart2p"
        tenthLabel = self.childNode(withName: "tenth") as! SKLabelNode!
        tenthLabel.fontName = "PressStart2p"
        
        //Array of leaderboard labels
        var leaderboardScores = [firstLabel, secondLabel, thirdLabel, fourthLabel, fifthLabel, sixthLabel, seventhLabel, eighthLabel, ninethLabel, tenthLabel]
        
        highscoreLabelNode = self.childNode(withName: "highscoreLabel") as! SKLabelNode!
        highscoreLabelNode.fontName = "PressStart2p"
        highscoreLabelNode.text = "\(preferences.value(forKey: "highscore") as! Int)"
        
        backNode = self.childNode(withName: "BackButton") as! SKSpriteNode!
        print("---------------------------------\n FirebaseReference \n---------------------\n")
        
        
        
        
        //There is a better way to do this.....
        //Sorts the results from firebase query of leaderboard and displays the top ten
        leaderboardquery.queryOrderedByValue().observe(.value, with: { snapshot in
            let myDict = snapshot.value as! NSDictionary
            var unSorted = Array<Int>()
            for (_, value) in myDict{
                unSorted.append(value as! Int)
            }
            if(unSorted.count != myDict.count){print("unSorted count != myDict count")}
            unSorted.sort{ return $0 > $1 }
            
            //Setting text for each of the top ten leader spots
            for index in 0...9{
                print("\(unSorted[index])")
                print("\(myDict.allKeys(for: unSorted[index]))")
                let indentifier = (myDict.allKeys(for: unSorted[index])[0] as AnyObject).components(separatedBy: ",")
                leaderboardScores[index]!.text = "\(unSorted[index])" + "   \(indentifier[0])"
                if indentifier[1] == UIDevice.current.identifierForVendor!.uuidString{
                    leaderboardScores[index]!.fontColor = UIColor.yellow
                }
            }
            print("\(myDict)")
        })
        
    }
    
    //Handles touching the back button to transition back to the main menu
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
        }
    }
    
}
