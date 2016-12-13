//
//  CoinPattern.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/11/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit




class CoinPattern:SKNode {
    
    var patterns = ["money_pattern1","money_pattern2","money_pattern3","money_pattern4"]
    var minRows = 9 // Hardcoded value. No pattern will be less that 9 rows, yet....
    var NumColumns:Int!
    var NumRows:Int!
    var size:CGSize
    
    // This will need to be dynamic
    let tileWidth = 25
    let tileHeight = 50
    // This will need to be read from the json file
    fileprivate var coins:Array2D<Coin>!

    init(scene: SKScene, duration:TimeInterval){
        //1. Chose a random pattern to generate
        
        patterns = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: patterns) as! [String]
        
        //2. load json file and set initial values
        let dictionary = Dictionary<String,Any>.loadJSONFromBundle(filename: patterns[0])
        let array = dictionary?["tiles"] as? [[Int]]
        NumColumns = dictionary?["numCols"] as? Int
        NumRows = dictionary?["numRows"] as? Int
        coins = Array2D<Coin>(columns: NumColumns, rows: NumRows)
        self.size = CGSize(width: tileWidth*NumColumns, height: tileHeight*NumRows)
        //3. Generate pattern
        super.init()
        let rand = GKRandomDistribution(lowestValue: Int(-scene.size.width/2) + Int(self.size.width/2),
                                        highestValue: Int(scene.size.width/2) - Int(self.size.width/2))
        let randN = CGFloat(rand.nextInt())
        print("random pt for money position  = \(randN)")
        //4. Place on scene and move
        for (row,array) in (array?.enumerated())!{
            let currRow = NumRows - row - 1 // Start indexing at 0 not 1
            for (col, value) in array.enumerated(){
                if value == 1 {
                    // Add a Coin :)
                    coins[col,currRow] = Coin(width: tileWidth, height: tileHeight)
                    coins[col,currRow]?.position = pointFor(column: col, row: currRow,
                                                            random:randN, size:scene.size)
                    coins[col,currRow]?.begin(tileHeight: tileHeight, row: row, size:scene.size, pattern:self.size, dur:duration*Double(NumRows/minRows))

                    scene.addChild(coins[col,currRow]!)
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func coinAt(column: Int, row: Int) -> Coin? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return coins[column, row]
    }

    
    func pointFor(column:Int, row:Int, random:CGFloat, size:CGSize)->CGPoint {
        let xPos = Int(random) + column * tileWidth + tileWidth/2
        let y =  row * tileHeight + tileHeight/2
        let yPos = Int(size.height/2) + Int(self.size.height/2) + y
        return CGPoint(x: xPos,y: yPos)
    }
    
}
