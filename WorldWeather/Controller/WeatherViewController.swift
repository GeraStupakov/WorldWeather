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
    
    // MARK - IBOutlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.endEditing(true)
    }
    
    //MARK - add new weather location
    @IBAction func AddWeatherLocaiton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add weather location?", message: "", preferredStyle: .alert)
        
//        let alertActionAdd = UIAlertAction(title: "Add", style: .default) { (alertActionAdd) in
//            <#code#>
//        }
//
//        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default) { (alertActionCancel) in
//            <#code#>
//        }
//
//        alert.addAction(alertActionAdd)
//        alert.addAction(alertActionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        location.requestLocation()
    }
    
    @IBAction func openWeatherList(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWeatherList", sender: self)
    }
    
}


    // MARK - CLLocationManagerDelegate
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


    // MARK - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func updateWeather(_ weatherManager: WeatherManager, weatherData: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weatherData.temperatureString)°"
            self.cityLabel.text = weatherData.cityName
            self.countryLabel.text = weatherData.countryCode
            self.humidityLabel.text = "\(String(weatherData.humidity)) %"
            self.pressureLabel.text = "\(String(weatherData.pressure)) hPa"
            self.windSpeedLabel.text = "\(weatherData.windSpeedString) m/s"
            self.weatherDescriptionLabel.text = weatherData.description
            self.weatherImage.image = UIImage(named: weatherData.imageWeather)
            self.dateLabel.text = weatherData.convertedDate
        }
    }
    
    func errorManager(error: Error) {
        print(error)
    }
}


    // MARK - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.text = cityLabel.text
            searchTextField.placeholder = "Enter city"
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchNameWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}
