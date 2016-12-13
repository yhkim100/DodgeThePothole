//
//  ConePattern.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/11/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit




class ConePattern:SKNode {
    
    var patterns = ["cone_pattern1","cone_pattern2","cone_pattern3"]
    var minRows = 9 // Hardcoded value. No pattern will be less that 9 rows, yet....
    var NumColumns:Int!
    var NumRows:Int!
    var size:CGSize
    var pauseTime:TimeInterval!
    
    // This will need to be dynamic
    let tileWidth = 40
    let tileHeight = 40
    // This will need to be read from the json file
    fileprivate var cones:Array2D<Cone>!

    init(scene: SKScene, duration:TimeInterval){
        //1. Chose a random pattern to generate
        
        patterns = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: patterns) as! [String]
        NumColumns = 0
        NumRows = 0
        cones = Array2D<Cone>(columns: NumColumns, rows: NumRows)
        self.size = CGSize(width: 0, height: 0)
        pauseTime = 25 * (Double(duration)/startGameSpeed)
        super.init()
        var array:[[Int]]!
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            let dictionary = Dictionary<String,Any>.loadJSONFromBundle(filename: self.patterns[0])
            array = (dictionary?["tiles"] as? [[Int]])!
            self.NumColumns = dictionary?["numCols"] as? Int
            self.NumRows = dictionary?["numRows"] as? Int
            self.cones = Array2D<Cone>(columns: self.NumColumns, rows: self.NumRows)
            self.size = CGSize(width: self.tileWidth*self.NumColumns,
                               height: self.tileHeight*self.NumRows)
            let rand = GKRandomDistribution(lowestValue: Int(scene.size.width*coneRange.low.rawValue),
                                            highestValue: Int(scene.size.width*coneRange.high.rawValue) - Int(self.size.width))
            let randN = CGFloat(rand.nextInt())
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                print("random pt for cone position  = \(randN)")
                for (row,array) in (array.enumerated()){
                    let currRow = self.NumRows - row - 1 // Start indexing at 0 not 1
                    for (col, value) in array.enumerated(){
                        if value == 1 {
                            // Add a Cone :)
                            self.cones[col,currRow] = Cone(width: self.tileWidth, height: self.tileHeight)
                            self.cones[col,currRow]?.position = self.pointFor(column: col, row: currRow,
                                                                              random:randN, size:scene.size)
                            self.cones[col,currRow]?.begin(tileHeight: self.tileHeight, row: row, size:scene.size, pattern:self.size, dur:duration*Double(self.NumRows/self.minRows))
                            
                            scene.addChild(self.cones[col,currRow]!)
                        }
                        else if value == 2 {
                            if (row == 0) || (row == self.NumRows-1){
                                let barricade = Barricade(width: self.tileWidth,
                                                          height: self.tileHeight)
                                barricade.position = self.pointFor(column: col,
                                                                   row: currRow,
                                                                   random: randN,
                                                                   size: scene.size)
                                barricade.begin(tileHeight: self.tileHeight, row: row, size: scene.size, pattern: self.size, dur: duration*Double(self.NumRows/self.minRows))
                                scene.addChild(barricade)
                            }
                        }
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCones(scene:SKScene, duration:TimeInterval){
        let rand = GKRandomDistribution(lowestValue: Int(-size.width/2) + Int(self.size.width/2),highestValue: Int(size.width/2) - Int(self.size.width/2))
        let randN = CGFloat(rand.nextInt())
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                let currCone = self.coneAt(column: column, row: row)
                if currCone != nil {
                    scene.addChild(currCone!)
                    currCone?.position  = pointFor(column: column, row: row, random:randN, size:scene.size)
                    currCone?.begin(tileHeight: tileHeight, row: row, size:scene.size, pattern:self.size, dur:duration)
                }
            }
        }
    }
    
    
    func coneAt(column: Int, row: Int) -> Cone? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return cones[column, row]
    }

    
    func pointFor(column:Int, row:Int, random:CGFloat, size:CGSize)->CGPoint {
        let xPos = Int(random) + column * tileWidth + tileWidth/2
        let y =  row * tileHeight + tileHeight/2
        let yPos = Int(size.height/2) + Int(self.size.height/2) + y
        return CGPoint(x: xPos,y: yPos)
    }
    
    func returnPauseTime()->TimeInterval{
        return self.pauseTime
    }
    
}
