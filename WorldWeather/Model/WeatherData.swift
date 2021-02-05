//
//  WeatherData.swift
//  WorldWeather
//
//  Created by Георгий Ступаков on 1/27/21.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let wind: Wind
    let weather: [Weather]
    let sys: Sys
    let dt: Double
}

struct Main: Decodable {
    let temp: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Decodable {
    let speed: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}

struct Sys: Decodable {
    let country: String
}



