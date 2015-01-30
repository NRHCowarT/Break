//
//  GameData.swift
//  Break
//
//  Created by Nick Cowart on 1/29/15.
//  Copyright (c) 2015 Nick Cowart. All rights reserved.
//

import UIKit

let _mainData: GameData = { GameData() }()

class GameData: NSObject {
    
    var topScore: Int = 0
    
    var gamesPlayed : [[String:Int]] = []
//                         ^^this is declaring an array with a dictionary inside it
    
    var currentGame: [String:Int]? {
//                        ^^this is declaring a dictionary
        
        get {
            
            return gamesPlayed[gamesPlayed.count - 1]

        }
        
        set{
            
            gamesPlayed[gamesPlayed.count - 1] = newValue!
            
        }
        
    }
    
//    (col,row)
    var allLevels = [
    
        (4,1),
        (5,2),
        (6,2),
        (7,2),
        (7,3),
        (8,3),
        (9,3),
        (7,4),
        (8,4),
        (9,4),
        (10,4),
        (11,4),
        (12,4),
        (12,5),
        
    ]
    
    var currentLevel = 0
   
    class func mainData() -> GameData  {
        
        return _mainData
    
    }
    
    func startGame() {
        
        gamesPlayed.append([
            
            "livesLost":0,
            "bricksBusted":0,
            "levelBeaten":0,
            "totalScore":0
            
            ])
    }
    
    func adjustValue(difference: Int, forKey key: String) {
        
        if var value = currentGame?[key] {
            
            currentGame?[key] = value + difference
        }
        
    }
}



// GameDate.mainData()