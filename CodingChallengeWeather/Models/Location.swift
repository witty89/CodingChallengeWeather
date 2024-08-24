//
//  Location.swift
//  CodingChallengeWeather
//
//  Created by Alex on 8/24/24.
//

import Foundation
struct Location: Decodable {
    let name: String
    let localNames: [String: String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
