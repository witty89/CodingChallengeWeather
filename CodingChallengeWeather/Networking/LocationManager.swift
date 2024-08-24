//
//  LocationManager.swift
//  CodingChallengeWeather
//
//  Created by Alex on 8/24/24.
//

import CoreLocation
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var locationCompletion: ((CLLocation?) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation(completion: @escaping (CLLocation?) -> Void) {
        self.locationCompletion = completion
        locationManager.requestLocation()
    }
    
    // CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationCompletion?(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Could not get location: \(error.localizedDescription)")
        locationCompletion?(nil)
    }
}
