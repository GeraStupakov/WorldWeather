//
//  WeatherCell.swift
//  WorldWeather
//
//  Created by Георгий Ступаков on 2/5/21.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewLabel: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewLabel.layer.cornerRadius = viewLabel.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
