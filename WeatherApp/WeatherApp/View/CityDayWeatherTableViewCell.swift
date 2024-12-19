//
//  CityDayWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Aubergine on 18/12/24.
//

import UIKit
import SDWebImage

class CityDayWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var superView: UIView!{
        didSet{
            guard let view = self.superView else { return }
            view.layer.cornerRadius = 15
            view.backgroundColor = UIColor(red: 30.0/255.0, green: 33.0/255.0, blue: 58.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var labelDayName: UILabel! {
        didSet{
            guard let label = self.labelDayName else { return }
            label.font = .appFont(size: 15, weight: .bold)
            label.textColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var labelHighTemperature: UILabel!{
        didSet{
            guard let label = self.labelHighTemperature else { return }
            label.font = .appFont(size: 15, weight: .medium)
            label.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var labelLowTemperature: UILabel!{
        didSet{
            guard let label = self.labelLowTemperature else { return }
            label.font = .appFont(size: 15, weight: .regular)
            label.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var iconWeatherType: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populate(weatherModel : WeatherList) {
        self.labelDayName.text = CommonDateFormatter.getDayFromTimeStamp(timeStamp: weatherModel.date)
        
        self.labelLowTemperature.text = "\(Int(weatherModel.main.temp_min))\(Constants.TEMPERATURE_ICON)"
        self.labelHighTemperature.text = "\(Int(weatherModel.main.temp_max)) \(Constants.TEMPERATURE_ICON)"
        
        if let url = URL(string: Constants.ICON_BASEURL + (weatherModel.weather.first?.icon ?? "") + Constants.IMAGE_PNG_EXTENSION) {
            self.iconWeatherType.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.iconWeatherType.sd_setImage(with: url)
        }
    }
}
