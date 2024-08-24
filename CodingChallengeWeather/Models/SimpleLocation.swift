//
//  SimpleLocation.swift
//  CodingChallengeWeather
//
//  Created by Alex on 8/24/24.
//

import Foundation
struct SimpleLocation: Hashable, Identifiable {
    let id = UUID()
    let city: String
    let state: String?
    let country: String
    
    func locationText() -> String {
        var text = "\(city)"
        if let state = state {
            text += ", \(state)"
        }
        text += ", \(country)"
        return text
    }

    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(city)
        hasher.combine(state)
        hasher.combine(country)
    }

    static func ==(lhs: SimpleLocation, rhs: SimpleLocation) -> Bool {
        return lhs.city == rhs.city && lhs.state == rhs.state && lhs.country == rhs.country
    }
}
