//
//  ViewController.swift
//  WorldWeather
//
//  Created by Георгий Ступаков on 1/26/21.
//

import UIKit
import CoreLocation
import CoreData

class WeatherViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    let location = CLLocationManager()
    
    // Created context of core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        loadWeatherItem()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.endEditing(true)
    }
    
    
    //MARK - add new weather location
    @IBAction func AddWeatherLocaiton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add weather location?", message: "", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.darkGray
    
        // Add alert button
        let alertActionAdd = UIAlertAction(title: "Add", style: .default) { (alertActionAdd) in
            
            let newWeatherItem = WeatherItem(context: self.context)
            newWeatherItem.city = self.cityLabel.text!
            newWeatherItem.country = self.countryLabel.text!
            newWeatherItem.info = self.weatherDescriptionLabel.text!
            newWeatherItem.temp = self.temperatureLabel.text!
            
            weatherlistArray.append(newWeatherItem)
            self.saveWeatherItem()
        }
        
        // Cancel alert button
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(alertActionAdd)
        alert.addAction(alertActionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Save core data
    func saveWeatherItem() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Load core data
    func loadWeatherItem(with request: NSFetchRequest<WeatherItem> = WeatherItem.fetchRequest()) {
        
        do {
            weatherlistArray = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Update core data
    func updateData() {
        
      //  weatherlistArray[0].setValue(<#T##value: Any?##Any?#>, forKey: "temp")
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
        print(error.localizedDescription)
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
        print(error.localizedDescription)
    }
}

    // MARK - WeatherListDelegate
extension WeatherViewController: WeatherListDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWeatherList" {
            let destinationVC = segue.destination as! WeatherListViewController
            destinationVC.delegate = self
        }
    }
    
    func fetchCityToWeatherVC(city: String) {
        weatherManager.fetchNameWeather(cityName: city)
    }
    
}
