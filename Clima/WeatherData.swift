//
//  WeatherData.swift
//  Clima
//
//  Created by Pritivi S Chhabria on 7/1/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    var name: String
    var main: Main
    var weather: [Weather]
}

struct Main: Codable {
    var temp: Double
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
