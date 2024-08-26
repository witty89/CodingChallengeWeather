//
//  CodingChallengeWeatherTests.swift
//  CodingChallengeWeatherTests
//
//  Created by Alex on 8/24/24.
//

import XCTest
@testable import CodingChallengeWeather

final class CodingChallengeWeatherTests: XCTestCase {
    func testConvertTemp() {
        let viewModel = DetailViewViewModel(location: SimpleLocation(city: "TestCity", state: nil, country: "TestCountry"))

        // Kelvin to Fahrenheit
        let fahrenheitResult = viewModel.convertTemp(temp: 300, from: .kelvin, to: .fahrenheit)
        XCTAssertEqual(fahrenheitResult, "80.33°F", "Conversion from Kelvin to Fahrenheit is incorrect")

        // Kelvin to Celsius
        let celsiusResult = viewModel.convertTemp(temp: 300, from: .kelvin, to: .celsius)
        XCTAssertEqual(celsiusResult, "26.85°C", "Conversion from Kelvin to Celsius is incorrect")

        //
        let neg40Result = viewModel.convertTemp(temp: -40, from: .fahrenheit, to: .celsius)
        XCTAssertEqual(neg40Result, "-40°C", "Conversion from Fahrenheit to Celsius is incorrect")
    }
    
    
}
