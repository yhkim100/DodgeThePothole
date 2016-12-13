//
//  AudioScene.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//  
/** This scene has three buttons: sfx, music, next song and back.
    Upon selecting the sfx button it is either enabled or disabled
    depending on what is currently stored as the user default (same for the music button).
    The button is changed from on to off or vice versa when pressed
    for both enabling/disabling music and sfx.
*/

import SpriteKit



class AudioScene: SKScene{
    var sfxToggleNode: SKSpriteNode!
    var musicToggleNode: SKSpriteNode!
    var backAudioNode: SKSpriteNode!
    
    var songSelectedLabel: SKLabelNode!
    var nextLabel: SKLabelNode!
    var musicTitle: SKLabelNode!
    
    var songsArray = Array<String>()
    
    var sfx: Bool!
    var music: Bool!
    
    override func didMove(to view: SKView) {
        
        //Initializing Buttons and Labels for scene
        sfxToggleNode = self.childNode(withName: "SFXButton") as! SKSpriteNode!
        musicToggleNode = self.childNode(withName: "MusicButton") as! SKSpriteNode!
        backAudioNode = self.childNode(withName: "BackButton") as! SKSpriteNode!
        songSelectedLabel = self.childNode(withName: "SongSelected") as! SKLabelNode!
        songSelectedLabel.fontName = "PressStart2p"
        let songName = "\(preferences.value(forKey: "song_selected")!)".components(separatedBy: ".")
        songSelectedLabel.text = songName[0]
        
        nextLabel = self.childNode(withName: "NextSong") as! SKLabelNode!
        nextLabel.fontName = "PressStart2p"
        musicTitle = self.childNode(withName: "InGameMusic") as! SKLabelNode!
        nextLabel.fontName = "PressStart2p"
        createSongsArray()
        
        //Get user's saved defaults for sfx and music and set sfx and music equal to these here
        if(preferences.bool(forKey: "sfx") == false){
            print("sfx is disabled")
            sfxToggleNode.texture = SKTexture(imageNamed: "offButton")
        }
        if(preferences.bool(forKey: "music") == false){
            print("music is disabled")
            musicToggleNode.texture = SKTexture(imageNamed: "music_pressed")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            let transition = SKTransition.flipHorizontal(withDuration: 1.0)
            let node = nodesArray.first as? SKSpriteNode
            
            //Sound Effects On/Off pressed - update value in preferences
            if nodesArray.first?.name == "SFXButton" {
                if(node?.texture?.description == SKTexture(imageNamed: "onButton").description){
                    node?.texture = SKTexture(imageNamed: "offButton")
                    sfx = false
                }
                else{
                    node?.texture = SKTexture(imageNamed: "onButton")
                    sfx = true
                }
                preferences.setValue(sfx, forKey: "sfx")
                preferences.synchronize()
            }
            //Music Button On/Off pressed - update value in preferences
            else if nodesArray.first?.name == "MusicButton" {
                if(node?.texture?.description == SKTexture(imageNamed: "music").description){
                    node?.texture = SKTexture(imageNamed: "music_pressed")
                    music = false
                }
                else{
                    node?.texture = SKTexture(imageNamed: "music")
                    music = true
                }
                preferences.setValue(music, forKey: "music")
                preferences.synchronize()
            }
            //Next song button pressed - change displayed song's text and user preferences for selected_song
            else if nodesArray.first?.name == "NextSong" {
                if songsArray.count > 1{
                    var index = songsArray.index(of: preferences.value(forKey: "song_selected") as! String)
                    index = (index! + 1) % songsArray.count
                    preferences.set(songsArray[index!], forKey: "song_selected")
                    let songName = "\(preferences.value(forKey: "song_selected")!)".components(separatedBy: ".")
                    songSelectedLabel.text = songName[0]
                }
            }
            
            //Back Button is pressed
            else if nodesArray.first?.name == "BackButton"{
                let settingsScene = SKScene(fileNamed: "SettingsScene")
                settingsScene?.scaleMode = .aspectFit
                self.view?.presentScene(settingsScene!, transition: transition)
            }
        }
    }
    
    //Creates an array of the names of all unlocked songs
    func createSongsArray(){
        let songsList = preferences.dictionary(forKey: "songs") as? Dictionary<String, Bool>
        for (key,value) in songsList!{
            if value == true {
                songsArray.append(key)
            }
        }
    }
    //Updates the selected song text label
    override func update(_ currentTime: TimeInterval) {
        let songName = "\(preferences.value(forKey: "song_selected")!)".components(separatedBy: ".")
        songSelectedLabel.text = songName[0]
    }
}
