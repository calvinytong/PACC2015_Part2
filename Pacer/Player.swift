//
//  Player.swift
//  ParseTest
//
//  Created by Calvin on 5/11/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation

class Player
{
    var name : String
    var score : NSInteger
    var teams : [String]
    var ObjectID : String
    
    init(name : String)
    {
        self.name = name
        self.score = 0
        teams = [String]()
        self.ObjectID = ""
    }
    
    func addTeam(team : String)
    {
        teams.append(team)
    }
}