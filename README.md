
# Smart Sun
## By Frank D'Agostino, Cam Morgan, and Leo Shao (2019)
#### Harvard CS50 Final Project
---
## Introduction
Smart Sun is an interactive IOS mobile application that allows the user to choose any location in the world and be able to get weather information from their desired location. The app has several components, including opening a map view of the world, adding pins to different locations, storing those locations in a table view, and a screen with information about the location picked and a background to represent the brightness and color saturation of the sun in that location. As such, this app allows the user to be able to easily and quickly emulate the light conditions of anywhere in the world.

## File Descriptions
|File|Description  |
|--|--|
|MainViewController.swift  | The view controller that the user sees when they first open the app. When the app is first opened, this view will have no entries in the table. From this view, the user can go to the MapViewController by clicking the "Select Location" button at the top right corner. The MainViewController uses the coordinates selected by the user to grab the API data and send it to the location view controller. It also displays all selected locations on-screen and allows the user to press them to go to that location's respective page. |
|MapViewController.swift| The MapViewController is responsible for displaying the MKMapKit framework to the user. A navigatable map is presented to the user, where they can traverse it by dragging the screen to look anywhere in the world. This file is responsible for placing the pins in whatever location the user long-presses, and sending the coordinate information of that location back to the MainViewController to place it into a table and also garner the necessary API data for the respective coordinates.|
|LocationViewController.swift| The LocationViewController is responsible for displaying each individual location's light conditions. Using the data gathered in the MainViewController, it calculates the respective brightness and color of the screen and background depending on weather conditions and the time of day. |
|Location.swift| This file is responsible for the storing the location data gathered from the map annotations so it can be utilized in other ViewControllers.
|WeatherData.swift|This file is responsible for passing all of the weather data garnered by the API so the data can be passed to the LocationViewController via one variable as opposed to multiple.|
|Main.storyboard|This file contains all of the ViewControllers for the main app in an interactive UI and design. All of the segues and navigation routes are also present here visually.|
|LaunchScreen.storyboard|This file contains the ViewController for the launch screen in an interactive UI and design, along with the SmartSun logo|
|smartsun.png| Logo image to display when user opens the application|


## Running the Application

In order to run the application, make sure all of the following files are present:
 - MainViewController.swift
 - MapViewController.swift
 - LocationViewController.swift
 - Location.swift
 - WeatherData.swift
 - Main.storyboard
 - LaunchScreen.storyboard
 - smartsun.png
 - AppDelegate.swift
 - SceneDelegate.swift
 - sun.png
 - lightbulb.png
 - info.plist
 - Assets.xcassets (folder)

When present, then be sure to have all of the files present in the latest version of XCode (11.2.1). The project name should be "SmartSun". Then, in order to run the application, there are two options:

 1. Simulation
If planning to run the application via simulation provided by XCode, first make sure the simulated device is some type of iPhone by going to the top left corner of the XCode application. After making sure it is an iPhone (preferably iPhone 11), then press the black play button at the same location. After waiting a few moments, a new screen should popup, simulating an iPhone.

 2. External iPhone Device
If planning to run the application on an actual iPhone, an Apple Lightning to USB-C cable must be used to connect the desired iPhone to the Apple computer/laptop. Make sure the desired iPhone is running IOS 13.1 (as all tests were done on this version on IOS and so testing in other versions is unclear, but there should be no issues in other recent versions). Furthermore, the desired iPhone must have the necessary settings in order to download developer applications.  Then, make sure to switch the desired device at the top right hand corner of XCode and select the connected device. It is then possible to press the black play button at the same location, which will then download and open the application on the physical iPhone.

Now with the application running, there should be a screen with blank table entries. At the top right should be a blue button called "Select Location". Tap/click on this button and you will be taken to a screen with an Apple map. If running on an external iPhone device, the navigation controls for the map are identical to any other iPhone map, utilizing drag to move and pinch to zoom. If running a simulation on your computer, click and drag with the mouse to move and double click to zoom. The purpose of the map is to allow the user to select locations where they want to obtain weather data. The application is built so the user can mark multiple locations at once. To mark a location, simply long tap/click where you want to mark and an annotation pin will appear. You may do this as many times as you want, and all pins will be saved.

Tapping the blue button in the top left marked "Locations" will take you back to the main table view, which should now be populated with all the locations marked on the map (labeled as "Location 1," "Location 2," etc.). Tapping on a cell in the table will take the user to a new page.

This new page should now display a colored screen with the informational values displayed. The brightness of the screen should also change (it may be very small and not noticeable if coincidentally the location picked had the same brightness currently operating). That screen now depicts the color and brightness depending on the UV index, weather, and time of day.

Feel free to mess around and pick different locations currently undergoing different seasons and time zones!
