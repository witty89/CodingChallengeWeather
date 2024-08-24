//
//  SearchViewViewModel.swift
//  CodingChallengeWeather
//
//  Created by Alex on 8/24/24.
//

import Combine
import MapKit

class SearchCompleterDelegate: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [MKLocalSearchCompletion] = []

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}

class SearchViewViewModel: ObservableObject {
    // gets the location options from the user search
    let completer = MKLocalSearchCompleter()
    
    // properties for getting the user location
    private var locationManager = LocationManager()
    @Published var location: CLLocation?
    @Published var locationDescription: String?
    @Published var error: String?

    init() {
        locationManager.locationCompletion = { [weak self] location in
            if let location = location {
                self?.location = location
                self?.fetchAddress(from: location)
                self?.error = nil
            } else {
                self?.location = nil
                self?.locationDescription = nil
                self?.error = "Unable to fetch location."
            }
        }
    }

    func locationText(location: SimpleLocation) -> String {
        var text = "\(location.city)"
        if let state = location.state {
            text += ", \(state)"
        }
        text += ", \(location.country)"
        return text
    }
    
    func performSearch(query: String) {
        completer.queryFragment = query
    }
    
    func getCityList(results: [MKLocalSearchCompletion]) -> [SimpleLocation] {
        
        // create each location item, use the set to eliminate duplicates
        var searchResults: Set<SimpleLocation> = []
        
        let filtered = results.filter { !$0.subtitle.contains("Search Nearby") && !$0.subtitle.contains("No Results Nearby") }
        for result in filtered {
            
            let titleComponents = result.title.components(separatedBy: ", ")
            let subtitleComponents = result.subtitle.components(separatedBy: ", ")
            
            // creating a SimpleLocation from either MKLocalSearchCompletion format
            locationFromSearchCompletion(titleComponents, subtitleComponents) {place in
                if place.city != "" && place.country != "" {
                    searchResults.insert(place)
                }
            }
        }
        
        // sorting alphabetically by city, same city name will sort by state, with no state coming first
        let sorted = Array(searchResults).sorted { lhs, rhs in
            if lhs.city == rhs.city {
                return lhs.state ?? "" < rhs.state ?? ""
            }
            return lhs.city < rhs.city
        }
        return sorted
    }

    // there are twp possible location formats, this handles either and returns a SimpleLocation
    func locationFromSearchCompletion(_ title: [String],_ subtitle: [String], _ completion: @escaping (SimpleLocation) -> Void) {
        
        var city: String = ""
        var state: String?
        var country: String = ""
        
        if title.count > 1 && subtitle.count > 1 {
            
            city = title.first!
            state = title[1]
            country = subtitle.count == 1 && subtitle[0] != "" ? subtitle.first! : title.last!
        } else {
            if title.count >= 1 && subtitle.count == 1 {
                
                city = title.first!
                if title.count > 1 {
                    state = title[1]
                }
                country = subtitle.last!
            }
        }
        completion(SimpleLocation(city: city, state: state, country: country))
    }
    
    func getPreviousCity() -> String? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "PreviousCity") as? String
    }
}

// MARK: - get user location functionality
extension SearchViewViewModel {
    
    // getting the lat lon for the user's location, so fetchAddress can reverse geocode it
    // first request permission
    func fetchLocation() {
        locationManager.getLocation { [weak self] location in
            
            /* it's getting
            (lldb) po location
            ▿ Optional<CLLocation>
              - some : <+40.41658202,-111.86003394> +/- 4.76m (speed 0.00 mps / course -1.00) @ 8/24/24, 5:49:01 PM Mountain Daylight Time
             */
            
            if let location = location {
                DispatchQueue.main.async {
                    self?.location = location
                    self?.fetchAddress(from: location)
                    self?.error = nil
                }
            } else {
                DispatchQueue.main.async {
                    self?.location = nil
                    self?.locationDescription = nil
                    self?.error = "Unable to fetch location."
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Location access granted
            break
        case .denied, .restricted:
            // Location access denied
            break
        case .notDetermined:
            // Permission not yet determined
            break
        @unknown default:
            break
        }
    }
    
    // reverse geocoding the lat lon to a readable address
    private func fetchAddress(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                self?.error = "Geocoding error: \(error.localizedDescription)"
                self?.locationDescription = nil
                return
            }
            
            if let placemark = placemarks?.first {
                var locationString = ""
                
                if let city = placemark.locality {
                    locationString += city
                }
                
                if let state = placemark.administrativeArea {
                    locationString += ", \(state)"
                }
                
                if let country = placemark.country {
                    locationString += ", \(country)"
                }
                
                self?.locationDescription = locationString
            } else {
                self?.locationDescription = "Location not found"
           }
        }
    }

}
