//
//  WeatherListViewController.swift
//  WorldWeather
//
//  Created by Георгий Ступаков on 2/5/21.
//

import UIKit
import CoreData

var listArray = [WheatherItem]()

class WeatherListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        cell.cityLabel.text = "\(listArray[indexPath.row].city!),  \(listArray[indexPath.row].country!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


