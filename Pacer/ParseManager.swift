//
//  ParseManager.swift
//  ParseTest
//
//  Created by Calvin on 5/11/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import Parse
import Bolts

class ParseManager
{
    //swift has weird stuff. Can't just do a static class
    init()
    {
        
    }
    
    func addStudent(player : Player) -> Void
    {
        let playerObject = PFObject(className: "Player")
        playerObject["name"] = student.name
        //studentObject["team"] = student.team
        playerObject["score"] = student.score
        playerObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success)
            {
                playerObject.objectId! = player.ObjectID
                println("Object has been saved.")
            }
           
        }
    }
    
    func pushScore(id : String, newScore : String)
    {
        var query = PFQuery(className:"GameScore")
        query.getObjectInBackgroundWithId("xWMyZEGZ") {
            (gameScore: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let gameScore = gameScore {
                gameScore["cheatMode"] = true
                gameScore["score"] = 1338
                gameScore.saveInBackground()
            }
        }
    }
}