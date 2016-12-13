//
//  GameViewController.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/7/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //intializes all unset user defaults
        initializeUserDefaults()
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: Function for initializing user defaults
    func initializeUserDefaults() {
        print("called initializeUserDefaults")
        //set default car
        if preferences.string(forKey: "car") == nil{
            preferences.setValue("car1", forKey: "car")
        }
        //set default preference for sound effects
        if preferences.string(forKey: "sfx") == nil{
            preferences.setValue(true, forKey: "sfx")
        }
        //set default preference for in-game music
        if preferences.string(forKey: "music") == nil{
            preferences.setValue(true, forKey: "music")
        }
        //set default user money ammount
        if preferences.string(forKey: "money") == nil{
            preferences.setValue(0, forKey: "money")
        }
        if preferences.string(forKey: "highscore") == nil{
            preferences.setValue(0, forKey: "highscore")
        }
        //intialize unlocked state of redcar
        if preferences.string(forKey: "redcar") == nil{
            preferences.setValue(false, forKey: "redcar")
        }
        //initialize unlocked state of greencar
        if preferences.string(forKey: "greencar") == nil{
            preferences.setValue(false, forKey: "greencar")
        }
        //initialize extra life state
        if preferences.string(forKey: "life") == nil {
            preferences.setValue(false, forKey: "life")
        }
        //initialize value for tank - invincibility upgrade
        if preferences.string(forKey: "tank") == nil{
            preferences.setValue(false, forKey: "tank")
        }
        //Prefences for song choice and song unlocked
        if preferences.dictionary(forKey: "songs") == nil{
            let songList = ["hot-pursuit.wav": true, "urban_chase.wav" : false, "catch_me.wav" : false, "race_duel.wav" : false]
            preferences.set(songList, forKey: "songs")
        }
        if preferences.string(forKey: "song_selected") == nil{
            preferences.set("hot-pursuit.wav", forKey: "song_selected")
        }
        preferences.synchronize()
    }
}
