
//  ParseManager.swift
//  Pacer
//
//  Created by Calvin on 5/11/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
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
    
    func pullObject(id : String, type : String) -> PFObject
    {
        var tempobj : PFObject = PFObject()
        var query = PFQuery(className: type)
        query.getObjectInBackgroundWithId(id) {
            (playerObject: PFObject?, error: NSError?) -> Void in
            if error != nil
            {
                println(error)
            }
            else if let playerObject = playerObject
            {
                tempobj = playerObject
                
            }
        }
        return tempobj
    }
    
    func pullPlayer(id : String) -> Player
    {
        return Player(player: pullObject(id, type: "Player"))
    }
    
    func pullTeam(id : String) -> Team
    {
        return Team(team : pullObject(id, type: "Team"))
    }
    
    func pullComp(id : String) -> Competition
    {
        return Competition(Competition: pullObject(id, type: "Competition"))
    }
}