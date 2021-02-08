//
//  WeatherListViewController.swift
//  WorldWeather
//
//  Created by Георгий Ступаков on 2/5/21.
//

import UIKit
import CoreData

protocol WeatherListDelegate: AnyObject {
    func fetchCityToWeatherVC(city: String)
}

var weatherlistArray = [WeatherItem]()

class WeatherListViewController: UIViewController {
    
    weak var delegate: WeatherListDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.reloadData()
    }
    
}

    // MARK - UITableViewDataSource and UITableViewDelegate
extension WeatherListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherlistArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WeatherCell
        
        cell.cityLabel.text = "\(weatherlistArray[indexPath.row].city!),  \(weatherlistArray[indexPath.row].country!)"
        cell.descriptionLabel.text = weatherlistArray[indexPath.row].info!
        cell.tempLabel.text = weatherlistArray[indexPath.row].temp!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.fetchCityToWeatherVC(city: weatherlistArray[indexPath.row].city!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            context.delete(weatherlistArray[indexPath.row])
            do {
                try context.save()
                weatherlistArray.remove(at: indexPath.row)
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
