//
//  WeatherData.swift
//  SmartSun
//
//  Created by Cam Morgan on 12/8/19.
//  Copyright © 2019 SmartSun Inc. All rights reserved.
//

import Foundation

import MapKit

class WeatherData {
    var uvIndex: [Double] = []
    var clouds: [Int] = []
    var desc: [String] = []
    var sunrise: [Int] = []
    var sunset: [Int] = []
    var timeInterval = Int(round(NSDate().timeIntervalSince1970))
    var title: [String] = []
    
    func reset() {
        uvIndex = []
        clouds = []
        desc = []
        sunrise = []
        sunset = []
        title = []
    }
}
