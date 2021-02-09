//
//  WeatherManager.swift
//  WorldWeather
//
//  Created by Георгий Ступаков on 1/27/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func updateWeather(_ weatherManager: WeatherManager, weatherModel: WeatherModel)
    func errorManager(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6116d0edac0cc71d59463248bcba2919&units=metric"
    
    func fetchNameWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString)
    }    
    
    func fetchGpsWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString)
    }
    
    func performRequestDS() {
        
        for i in 0 ..< weatherlistArray.count {
            guard let url = URL(string: "\(weatherURL)&q=\(weatherlistArray[i].city!)") else { return }
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.errorManager(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        weatherlistArray[i].setValue( weather.description, forKey: "info")
                        weatherlistArray[i].setValue( weather.temperatureString, forKey: "temp")
                    }
                }
            }
            task.resume()
        }
    }
    
    func performRequest(_ urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                delegate?.errorManager(error: error!)
                return
            }
            if let safeData = data {
                if let weather = self.parseJSON(safeData) {
                    delegate?.updateWeather(self, weatherModel: weather)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(WeatherData.self, from: weatherData)

            let name = decoderData.name
            let id = decoderData.weather[0].id
            let description = decoderData.weather[0].description
            let temp = decoderData.main.temp
            let pressure = decoderData.main.pressure
            let humidity = decoderData.main.humidity
            let speed = decoderData.wind.speed
            let country = decoderData.sys.country
            let date = decoderData.dt
            
            let weatherModel = WeatherModel(idWeather: id, cityName: name, temperature: temp, description: description, pressure: pressure, humidity: humidity, windSpeed: speed, countryCode: country, date: date)
            
            return weatherModel
        } catch {
            delegate?.errorManager(error: error)
            return nil
        }
    }
    
    
}
