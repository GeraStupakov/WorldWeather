//
//  ViewController.swift
//  WorldWeather
//
//  Created by Георгий Ступаков on 1/26/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    let location = CLLocationManager()
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.requestLocation()
        
        weatherManager.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        location.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchGpsWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


extension WeatherViewController: WeatherManagerDelegate {
    func updateWeather(_ weatherManager: WeatherManager, weatherData: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weatherData.temperatureString)°"
            self.cityLabel.text = weatherData.cityName
            self.countryLabel.text = weatherData.countryCode
            self.humidityLabel.text = "\(String(weatherData.humidity)) %"
            self.pressureLabel.text = "\(String(weatherData.pressure)) hPa"
            self.windSpeedLabel.text = "\(String(weatherData.windSpeed)) kmH"
            self.weatherDescriptionLabel.text = weatherData.description
            self.weatherImage.image = UIImage(systemName: weatherData.imageWeather)
        }
    }
}
