//
//  Alerts.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 12/1/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//  Found at: http://stackoverflow.com/questions/39557344/swift-spritekit-how-to-present-alert-view-in-gamescene

import SpriteKit

protocol Alerts { }
extension Alerts where Self: GameOverScene {
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            print(alertController.textFields?.first?.text! ?? "scrub")
            if (alertController.textFields?.first?.text!.characters.count)! > 2{
                let indexStartOfText = alertController.textFields?.first?.text!.index((alertController.textFields?.first?.text!.startIndex)!, offsetBy: 3)
                let first_three = alertController.textFields?.first?.text!.substring(to: indexStartOfText!)
                self.submissionName = first_three! + "," + UIDevice.current.identifierForVendor!.uuidString
                leaderboardquery.child(self.submissionName).setValue(preferences.value(forKey: "highscore"))
            }
            else{
                self.tooFewCharacters()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in}
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func tooFewCharacters(){
        let alertController = UIAlertController(title: "Too Short!", message: "Please enter 3 characters!", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { _ in
            self.showAlert(title: "New High Score!", message: "Insert 3 Characters")
        }
        alertController.addAction(dismissAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}

extension Alerts where Self: ShopScene{
    func doPurchase(title: String, message: String, cost: Int, item: String, itemName: String?=nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            //update money
            preferences.set(preferences.value(forKey: "money") as! Int - cost, forKey: "money")
            //update unlocked items
            if item != "song"{
                preferences.set(true, forKey: item)
                preferences.synchronize()
            }
            else{
                var songList = preferences.dictionary(forKey: "songs") as? Dictionary<String, Bool>
                songList?[itemName!] = true
                preferences.set(songList, forKey: "songs")
                preferences.synchronize()
            }
            self.updateCarTexture()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel){ _ in}
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func insufficientFunds(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel){ _ in}
        alertController.addAction(okAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func alreadyPurchased(){
        let alertController = UIAlertController(title: "Item Already Purchased!", message: "You have this item!", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel){ _ in}
        alertController.addAction(dismissAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

extension Alerts where Self: SKScene{
    func notUnlocked(){
        let alertController = UIAlertController(title: "Item Locked", message: "This item is not yet unlocked! You must first purchase it in the store!", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel){ _ in}
        alertController.addAction(dismissAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

extension Alerts where Self: GameScene{
    func showText(index:Int){
        let textArray = [
            "We're no strangers to love",
        "You know the rules and so do I",
        "A full commitment's what I'm thinking of",
        "You wouldn't get this from any other guy",
        "I just wanna tell you how I'm feeling",
        "Gotta make you understand",
        "Never gonna give you up",
        "Never gonna let you down",
        "Never gonna run around and desert you",
        "Never gonna make you cry",
        "Never gonna say goodbye",
        "Never gonna tell a lie and hurt you",
        "We've known each other for so long",
        "Your heart's been aching, but",
        "You're too shy to say it",
        "Inside, we both know what's been going on",
        "We know the game and we're gonna play it",
        "And if you ask me how I'm feeling",
        "Don't tell me you're too blind to see",
        "Never gonna give you up",
        "Never gonna let you down",
        "Never gonna run around and desert you",
        "Never gonna make you cry",
        "Never gonna say goodbye",
        "Never gonna tell a lie and hurt you",
        "Never gonna give you up",
        "Never gonna let you down",
        "Never gonna run around and desert you",
        "Never gonna make you cry",
        "Never gonna say goodbye",
        "Never gonna tell a lie and hurt you",
        "Never gonna give, never gonna give",
        "Never gonna give, never gonna give",
        "We've known each other for so long",
        "Your heart's been aching, but",
        "You're too shy to say it",
        "Inside, we both know what's been going on",
        "We know the game and we're gonna play it",
        "I just wanna tell you how I'm feeling",
        "Gotta make you understand",
        "Never gonna give you up",
        "Never gonna let you down",
        "Never gonna run around and desert you",
        "Never gonna make you cry",
        "Never gonna say goodbye",
        "Never gonna tell a lie and hurt you",
        "Never gonna give you up",
        "Never gonna let you down",
        "Never gonna run around and desert you",
        "Never gonna make you cry",
        "Never gonna say goodbye",
        "Never gonna tell a lie and hurt you",
        "Never gonna give you up",
        "Never gonna let you down",
        "Never gonna run around and desert you",
        "Never gonna make you cry",
        "Never gonna say goodbye",
        "Never gonna tell a lie and hurt you"]
        
        let alertController = UIAlertController(title: "New Text Message", message: textArray[index], preferredStyle: .actionSheet)
            print("Getting text number \(index)")
            print("\(textArray[index])")
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel){ _ in}
            alertController.addAction(dismissAction)
            self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
}

