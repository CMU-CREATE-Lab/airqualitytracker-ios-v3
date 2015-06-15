//
//  GetCurrentWeather.swift
//  V3
//
//  Created by Mohak Nahta  on 6/11/15.
//  Copyright (c) 2015 Speck Sensor. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    
    var temperature: Int
    var summary: String
    
    init(weatherDictionary: NSDictionary) {
        let currentWeather = weatherDictionary["currently"] as! NSDictionary
        
        temperature = currentWeather["temperature"] as! Int
        summary = currentWeather["summary"] as! String
        
    }
}