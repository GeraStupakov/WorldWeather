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
    let windSpeed: Double
    let countryCode: String
    let date: Double
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    var windSpeedString: String {
        return String(format: "%.1f", windSpeed)
    }
    
    var convertedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: Date(timeIntervalSince1970: date))
    }
    
    
    var imageWeather: String {
        switch idWeather {
        case 200...232:
            return "rain.bold"
        case 300...321:
            return "heavy-rain"
        case 500...531:
            return "rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "fog"
        case 800:
            return "sun"
        case 801:
            return "sun-cloud"
        case 802...804:
            return "cloud-bolt"
        default:
            return "cloud"
        }
    }
    
}
