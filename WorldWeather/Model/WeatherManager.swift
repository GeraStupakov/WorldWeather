//
//  WeatherManager.swift
//  WorldWeather
//
//  Created by Георгий Ступаков on 1/27/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func updateWeather(_ weatherManager: WeatherManager, weatherData: WeatherModel)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6116d0edac0cc71d59463248bcba2919&units=metric"
    
    func fetchGpsWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            if let safeData = data {
                if let weatherData = self.parseJSON(safeData) {
                    delegate?.updateWeather(self, weatherData: weatherData)
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
            
            let weatherModel = WeatherModel(idWeather: id, cityName: name, temperature: temp, description: description, pressure: pressure, humidity: humidity, windSpeed: speed, countryCode: country)
            
            return weatherModel
        } catch {
            print(error)
            return nil
        }
    }
    
    
}
