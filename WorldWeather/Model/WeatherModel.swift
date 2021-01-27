//
//  WeatherModel.swift
//  WorldWeather
//
//  Created by Георгий Ступаков on 1/27/21.
//

import Foundation

struct WeatherModel {
    let idWeather: Int
    let cityName: String
    let temperature: Double
    let description: String
    let pressure: Int
    let humidity: Int
    let windSpeed: Int
    let countryCode: String
    
    var temperatureString: String{
        return String(format: "%.0f", temperature)
    }
    
    var imageWeather: String {
        switch idWeather {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.heavyrain"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
