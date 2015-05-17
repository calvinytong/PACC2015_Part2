//
//  PedometerHelper.swift
//  PedometerTest4
//
//  Created by Calvin on 5/17/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import CoreMotion

class PedometerHelper
{
    let pedometer : CMPedometer
    var steps : NSInteger
    var available : Bool
    var startdate : NSDate
    
    init()
    {
        self.pedometer = CMPedometer()
        self.steps = 0
        self.available = true
        self.startdate = NSDate()
    }
    
    func startCollection()
    {
        self.startdate = NSDate()
        if(CMPedometer.isStepCountingAvailable())
        {
            self.pedometer.startPedometerUpdatesFromDate(NSDate()) { (data: CMPedometerData!, error) -> Void in
                if(error == nil)
                {
                    println("gucci")
                    self.steps = data.numberOfSteps as NSInteger
                    println(self.steps)
                }
            }
        }
        else
        {
            available = false
        }

    }
    
    func endCollection()
    {
        pedometer.stopPedometerUpdates()
    }
    
}