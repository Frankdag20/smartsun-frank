# Smart Sun
## By Frank D'Agostino, Cam Morgan, and Leo Shao (2019)
#### Harvard CS50 Final Project
---
## Introduction
Smart Sun is an interactive IOS mobile application that allows the user to choose any location in the world and be able to get weather information from their desired location. The app has several components, including opening a map view of the world, adding pins to different locations, storing those locations in a table view, and a screen with information about the location picked and a background to represent the brightness and color saturation of the sun in that location. As such, this app allows the user to be able to easily and quickly emulate the light conditions of anywhere in the world.
## APIs and Frameworks
In order to conduct the project, we utilized several resources to expedite the process and also get the necessary data for the calculations and implementation. One aspect of the application is the ability for the user to easily be able to choose a location anywhere in the world. The built-in Core Location framework from Apple was used. This allows the geographic location of the user to be obtained. It gathers data using all available components on the device, such as Wi-Fi, GPS information, barometer, and hardware. In order to display the map and allow the user to easily navigate the map, Apple's built-in MapKit framework was used. This framework allows the embedding of maps/satellite imagery directly into views. The user can then choose a location and get the geographic coordinates of that point of interest, then able to be used for the weather data. The API utilized  is called OpenWeatherMap, and as part of the OpenWeather project, accesses current weather for any location on Earth. This includes over 200,000 cities, and gathers the data based upon global models and over 40,000 weather stations. Within the API, the Current Weather Data and Ultraviolet Index sublibraries were used. Both were called by geographic coordinates. Coordinates were in terms of latitude and longitude. The API call for the Current Weather Data data is:  api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}.
An example of the API response is as follows:
`{`
`"coord": { "lon": 139,"lat": 35},`
`  "weather": [`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`    {`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`      "id": 800,`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `     "main": "Clear",`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`
"description": "clear sky",`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`     "icon": "01n"`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  `  }`
 ` ],`
`  "base": "stations",`
`  "main": {`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `   "temp": 289.92,`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  `  "pressure": 1009,`
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `   "humidity": 92,`
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  ` "temp_min": 288.71,`
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  ` "temp_max": 290.93`
 ` },`
 ` "wind": {`
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`   "speed": 0.47,`
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `  "deg": 107.538`
  `},`
  `"clouds": {`
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`   "all": 2`
 ` },`
 ` "dt": 1560350192,`
 ` "sys": {`
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`  "type": 3,`
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ` "id": 2019346,`
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ` "message": 0.0065,`
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`  "country": "JP",`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`    "sunrise": 1560281377,`
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`   "sunset": 1560333478`
`  },`
 ` "timezone": 32400,`
`  "id": 1851632,`
`  "name": "Shuzenji",`
`  "cod": 200`
`}`
The API call for the Ultraviolet Index is:
api.openweathe...nd=1498481991
An example of the response is as follows:
`{ `
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`"lat": 38.75, `
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`"lon": 40.25, `
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`"date_iso": "2017-06-23T12:00:00Z",`
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`"date": 1498219200,`
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`"value": 10.16`
`}`
Although there are a lot of parameters given in these API calls, not all were used. From the Current Weather Data, "description", "clouds", "sunrise", and "sunset" were used. Description gives a one word description of the weather conditions (such as "Rainy" or "Sunny"). Clouds gives the percentage of cloud coverage (for example, 0.7 would mean 70% cloud coverage, which is quite cloudy). Sunrise and sunset gives the time the sun rise and sets on that given day, but in Unix Epoch Time. This standard version of time is the amount of seconds elapsed since 00:00 January 1st, 1970, making it a standard 32 bit integer.
## Design
The app begins with the Smart Sun logo and opens to a home screen table view. Although blank for now, the user can then go to the map. When opening the map, it opens up a new view controller. The MapKit framework opens up a map interface, in which the user can then move the screen, and long-tap to mark a location with a pin. The user can then return to the home screen, where they see a table view of all locations they have chosen. They can then click on one of the table items to go to that locations specific page. In this view, a display pops up of that location's information. The background also changes in color and brightness depending on the time of day currently at that location, the UV index, cloudiness, and precipitation.
## API Utilization
Under MainViewController, the OpenWeather API had to be called and stored. Using the link for both the UV and Current Weather libraries. The API is called using a function, where the inputs are the latitude and longitude gathered from the location selector. Using a timer, the API data is called every 5 minutes within the app for each location. From the JSON, five of the entries datapoints are stored in global variables used for the color/brightness calculations.
## Map and Location Selector
Under the MapViewController, the MKMapView allows the user to move around a map view. It is then designed so the user can "select" a location by using a long-tap. Then, the application recognizes that long-tap and places a marker where the user pressed. The latitude and longitude information from that location is then stored. Using a segue, this information is sent to the MainViewController, where the location label populates the table view. The user can then click on that location to bring them to the LocationViewController.

## Brightness / Color Determination
Under LocationViewController, the user is brought to this page whenever they choose one of the entries under the table view. Based on the location they choose, this page displays some basic information regarding the location, and the background is dependent upon several factors. Based on the UV index, it increases the brightness of the color as well as the brightness of the phone screen. However, precipitation and cloudiness decreases the brightness of the background as well as the screen. Furthermore, the color of the background is dependent upon the time of day at that current location. During midday, the screen is maximally blue. At night, the screen is maximally black. By sunset/sunrise, the screen transitions to a reddish color saturation to either blue or black, depending on if it is dusk or dawn. These transitions are animated with a timer function. The display was also converted to represent Unix Epoch Time to standard UTC time.
## General Functions
Codables and user defaults were utilized to save user information when leaving the app. Furthermore, the API updates every single time the user goes to the LocationViewController, making it always up to date no matter when the user checks back into their location. Furthermore, delegates were utilized to handle information among ViewControllers. The tables were also made so they maintain their position by using a sort function and attaching a label to each individual LocationViewController.
## App Utility in the Real World
Sleep deprivation is a major problem in the modern world today. With the growing popularity of the 24 hour day, coupled with the availability of 24/7 communication, entertainment, and workflow, the body's natural clock is constantly impacted by these external forces. One of them is the blue light from phones, which trick human brains into thinking it is daytime when it is not, depleting the quality of sleep or making it difficult to fall asleep. Not only that, but with man-made things such as Daylight savings, graveyard shifts, or late school assignments, people no longer wake up and go to sleep at sunset or sunrise. Rather, they wake up at a different time, and the amount of sunlight they receive can be radically different than what the circadian rhythm requires to operate. As such, the idea of this application as well as its design was made keeping in mind these aspects of sleep health. With the application, users enduring the Boston winter where the sun sets at 4 PM can place their location in California, where there's usually little to no clouds and the sun is brighter. Even further, the user can select Sydney, Australia, where currently it's summer and their sunset is 8 PM! These differing sunrises and sunsets fall much more in line with most people's work days, making them more alert and get better sleep throughout the day.
