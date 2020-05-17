//
//  LocationViewController.swift
//  SmartSun
//
//  Created by Cam Morgan on 12/7/19.
//  Copyright © 2019 SmartSun Inc. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    
    var weatherData = WeatherData()
       var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(index)
        // Saves the weather stored in a global array into variables for
        // the individual cell tapped
        let uv = (weatherData.uvIndex[index]) / 12
        let coverage = Float(weatherData.clouds[index]) / 4
        let currentTime = Int(round(NSDate().timeIntervalSince1970))
        let rise = weatherData.sunrise[index]
        let set = weatherData.sunset[index]

        // Formats UTC unix epoch time into human-readable
        // time native to time zone
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        
        var color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        if abs(rise - currentTime) <= 30 {
            // Start sunrise color animation
            UIView.animate(withDuration: 30, delay: 0.0, options:[.repeat, .autoreverse], animations: {
                self.view.backgroundColor = UIColor(red: 1, green: 0.6863, blue: 0.5098, alpha: 1)
                }, completion:nil)
        } else if abs(currentTime - set) <= 30 {

            // Start sunset color animation
            UIView.animate(withDuration: 30, delay: 0.0, options:[.repeat, .autoreverse], animations: {
            self.view.backgroundColor = UIColor(red: 1, green: 0.9255, blue: 0.4588, alpha: 1.0)
            }, completion:nil)
        } else if currentTime > set {
            color = UIColor(red:0, green: 0, blue: 0, alpha:1.0)
        } else if currentTime < rise {
            color = UIColor(red:0, green: 0, blue: 0, alpha:1.0)
        } else {
            color = UIColor(red:0.8784, green: 0.9686, blue: 1, alpha:1.0)
        }
        
        // Aggregates data into a string and displays it
        let dataString = "Data\nUV: \(weatherData.uvIndex[index])\nCloud Coverage: \(weatherData.clouds[index])%\nCurrent Time: \(dayTimePeriodFormatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(currentTime)) as Date))\nSunrise: \(dayTimePeriodFormatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(rise)) as Date))\nSunset: \(dayTimePeriodFormatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(set)) as Date))\nAll times are displayed in your\ncurrent location's time zone"
        print(dataString)
        dataLabel.text = dataString


        UIScreen.main.brightness = CGFloat(uv)

        print(uv)
        print(coverage)
        print(color)
        self.view.backgroundColor = color.darker(by: CGFloat(coverage))
        //self.view.backgroundColor = UIColor.blue

    }
}

// Used from here to easily lighten and darken colors:
// https://stackoverflow.com/questions/38435308/get-lighter-and-darker-color-variations-for-a-given-uicolor
extension UIColor {
    
    func lighter(by percentage: CGFloat) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
