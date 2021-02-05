//
//  WeatherListViewController.swift
//  WorldWeather
//
//  Created by Георгий Ступаков on 2/5/21.
//

import UIKit

class WeatherListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listArray: [CellModel] = [
        CellModel(city: "Minsk", country: "BY", description: "Rainy", temp: "1"),
        CellModel(city: "Paris", country: "FRA", description: "Rainy", temp: "4"),
        CellModel(city: "Oslo", country: "NRW", description: "Rainy", temp: "-1")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    
}

extension WeatherListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WeatherCell
        
        cell.cityLabel.text = "\(listArray[indexPath.row].city), \(listArray[indexPath.row].country)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


