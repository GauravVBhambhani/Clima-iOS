//
//  WeatherData.swift
//  Clima
//
//  Created by Gaurav Bhambhani on 6/26/23.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let sys: Sys
    let name: String
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

struct Sys: Codable {
    let country: String
}
