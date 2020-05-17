//
//  MainViewController.swift
//  SmartSun
//
//  Created by Cam Morgan on 12/3/19.
//  Copyright © 2019 SmartSun Inc. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation

// Codables for API pulls
struct UV: Codable {
    let value: Double
}

struct Weather: Codable {
    let weather: [Desc]
    let clouds: [String: Int]
    let sys: Sys
}

struct Desc: Codable {
    let main: String
}

struct Sys: Codable {
    let sunrise: Int
    let sunset: Int
}

// Allows user's data to save when closed
struct UserData: Codable {
    var latitudes: [Double]
    var longitudes: [Double]
    var titles: [String]
}

class MainViewController: UITableViewController, MapViewControllerDelegate {
    // Initialize variables
    var locations = Location()
    var weatherData = WeatherData()
    
    var uvIndex: Double!
    var clouds: Int!
    var desc: String!
    var sunrise: Int!
    var sunset: Int!
    var timeInterval = Int(round(NSDate().timeIntervalSince1970))
    
    // Runs whenever this ViewController is shown
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        tableView.reloadData()
        
        let count = locations.latitudes.count
        
        // Reloads weather data based on chosen locations
        if count > 0 {
            weatherData.reset()
            for i in 0...count - 1 {
                getUV(locations.latitudes[i], locations.longitudes[i])
                getWeather(locations.latitudes[i], locations.longitudes[i])
                weatherData.title.append(locations.titles[i])
            }
        }
        
        // Saves user data
        saveUserDefaults((Any).self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations.latitudes = []
        locations.longitudes = []
        locations.titles = []
        
        // Loads user data
        loadUserDefaults((Any).self)
    }
    
    // Saves location data from MapViewController
    func doSomethingWith(data: Location) {
        locations = data
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.textLabel?.text = weatherData.title[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowLocationSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pushes data to LocationViewController
        if segue.identifier == "ShowLocationSegue" {
            let destination = segue.destination as! LocationViewController
                destination.weatherData = weatherData
                let index = tableView.indexPathForSelectedRow?.row
                destination.index = index!
        }
        // Pushes data to MapViewController
        if segue.identifier == "ShowMapSegue" {
            let destination = segue.destination as! MapViewController
            destination.delegate = self
            destination.locations = locations
        }
    }
    
    // Uses API call to get UV data
    func getUV(_ lat: Double, _ long: Double) {
        let _ = URLSession.shared
        let url = URL(string: "https://api.openweathermap.org/data/2.5/uvi?appid=6957b4c6b70541717c5d4476ac69ea14&lat=\(lat)&lon=\(long)")
        guard let u = url else {
            return
        }
        
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let uv = try JSONDecoder().decode(UV.self, from: data)
                self.weatherData.uvIndex.append(uv.value)
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    // Uses API call to get other weather data
    func getWeather(_ lat: Double, _ long: Double) {
        let _ = URLSession.shared
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=6957b4c6b70541717c5d4476ac69ea14&lat=\(lat)&lon=\(long)")
        guard let u = url else {
            return
        }
        
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                
                self.weatherData.clouds.append(weather.clouds["all"]!)
                self.weatherData.desc.append(weather.weather[0].main)
                self.weatherData.sunrise.append(weather.sys.sunrise)
                self.weatherData.sunset.append(weather.sys.sunset)
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    // Saves user data
    func saveUserDefaults(_ sender: Any) {
        let userData = UserData(latitudes: locations.latitudes, longitudes: locations.longitudes, titles: locations.titles)
        let defaults = UserDefaults.standard
        
        // Use PropertyListEncoder to convert Player into Data / NSData
        defaults.set(try? PropertyListEncoder().encode(userData), forKey: "userData")
    }
    
    // Loads user data
    func loadUserDefaults(_ sender: Any) {
        let defaults = UserDefaults.standard
        guard let userDataFull = defaults.object(forKey: "userData") as? Data else {
            return
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let userData = try? PropertyListDecoder().decode(UserData.self, from: userDataFull) else {
            return
        }
            
        locations.latitudes = userData.latitudes
        locations.longitudes = userData.longitudes
        locations.titles = userData.titles
    }
}
