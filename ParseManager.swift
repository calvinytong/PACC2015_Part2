
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
    var temparray : [PFObject] = [PFObject]()
    var teamarray : [Team] = [Team]()

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
    
    func pullAllObjects(type : String, completionHandler: (Bool!, NSError!) -> Void)
    {
        
        var query = PFQuery(className: type)
        //gets first 100 objects
        query.orderByAscending("score")
         query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) Teams.")
                // Do something with the found objects
                //println(objects)

                if let objectarray : [PFObject] = objects as? [PFObject] {
                    //println(objectarray)
                    self.temparray = objectarray
                    //println(temparray)
                    completionHandler(true, nil)
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
                completionHandler(false, nil)
            }
        }
        //println("I EXITED")
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
    
    func pullTeams(completionHandler: (Bool!, NSError!) -> Void)
    {
        self.teamarray = []
        var completed = false
        pullAllObjects("Team", completionHandler: {
            (success: Bool!, error: NSError!) -> Void in
            if success == true
            {
                for o in self.temparray
                {
                    self.teamarray.append(Team(team: o))
                }
                completionHandler(true, nil)
            }
        })
        
    }
    
    
}