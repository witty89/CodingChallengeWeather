//
//  CodingChallengeWeatherApp.swift
//  CodingChallengeWeather
//
//  Created by Alex on 8/24/24.
//

import SwiftUI

@main
struct CodingChallengeWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(viewModel: SearchViewViewModel())
        }
    }
}

/*Public API
 Create a free account at openweathermap.org. Just takes a few minutes. Full documentation for the service below is on their site, be sure to take a few minutes to understand it.
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid={API key}
 Built-in geocoding
 Please use Geocoder API if you need automatic convert city names and zip-codes to geo coordinates and the other way around.
 Please note that API requests by city name, zip-codes and city id have been deprecated. Although they are still available for use, bug fixing and updates are no longer available for this functionality.
 Built-in API request by city name
 You can call by city name or city name, state code and country code. Please note that searching by states available only for the USA locations.
 API call
 https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
 https://api.openweathermap.org/data/2.5/weather?q={city name},{country code}&appid={API key}
 https://api.openweathermap.org/data/2.5/weather?q={city name},{state code},{country code}&appid={API key}
  
 You will also need icons from here:
 http://openweathermap.org/weather-conditions
*/


/*
 Create a browser or native-app-based application to serve as a basic weather app.
 Search Screen
 ✅︎ Allow customers to enter a US city
 ✅︎ Call the openweathermap.org API and display the information you think a user would be interested in seeing. Be sure to has the app download and display a weather icon.
 Have image cache if needed ✅︎ not needed, the image request is quick enough, I'd rather make that request each time and keep the app as lightweight as possible, but would be a good team discussion
 ✅︎ Auto-load the last city searched upon app launch.
 ✅︎ Ask the User for location access, If the User gives permission to access the location, then retrieve weather data by default
 ✅︎Do no use external framework
 */

/*
 What is Important (subjective, but I feel good about these)
 Proper function – requirements met.
 Well-constructed, easy-to-follow, commented code (especially comment hacks or workarounds made in the interest of expediency (i.e. // given more time I would prefer to wrap this in a blah blah blah pattern blah blah )).
 Proper separation of concerns and best-practice coding patterns.
 Defensive code that graciously handles unexpected edge cases.
 */

/*
 Bonus Points!
 Unit Tests ✅︎
 Good design (I know I said it was less important, but what I mean is I don't want a beautiful, poorly constructed app).
 Industry-standard design pattern adoption (✅︎MVVM, VIPER, MVI)
 Adoption of SOLID principles.✅︎
 Additional functionality – whatever you see fit. ✅︎ Refresh, Conversion C to F
 */


