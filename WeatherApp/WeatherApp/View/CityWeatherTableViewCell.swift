//
//  CityWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Aubergine on 18/12/24.
//

import UIKit
import SDWebImage

class CityWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var superView: UIView!{
        didSet{
            guard let view = self.superView else { return }
            view.layer.cornerRadius = 15
            view.backgroundColor = UIColor(red: 30.0/255.0, green: 33.0/255.0, blue: 58.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var labelCityName: UILabel! {
        didSet{
            guard let label = self.labelCityName else { return }
            label.font = .appFont(size: 28, weight: .bold)
            label.textColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var labelTemperature: UILabel!{
        didSet{
            guard let label = self.labelTemperature else { return }
            label.font = .appFont(size: 40, weight: .medium)
            label.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var labelHighLowTemperature: UILabel!{
        didSet{
            guard let label = self.labelHighLowTemperature else { return }
            label.font = .appFont(size: 15, weight: .regular)
            label.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var labelWeatherCondition: UILabel!{
        didSet{
            guard let label = self.labelWeatherCondition else { return }
            label.font = .appFont(size: 14, weight: .regular)
            label.textColor = UIColor.lightGray
        }
    }
    
    @IBOutlet weak var iconWeatherType: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populate(weatherModel : WeatherModel) {
        self.labelCityName.text = weatherModel.city.name
        self.labelWeatherCondition.text = weatherModel.weatherList.first?.weather.first?.weatherDescription
        self.labelTemperature.text = "\(Int(weatherModel.weatherList.first?.main.temp ?? 0))\(Constants.TEMPERATURE_ICON)"
        self.labelHighLowTemperature.text = "H:\(Int(weatherModel.weatherList.first?.main.temp_max ?? 0)) \(Constants.TEMPERATURE_ICON) L:\(Int(weatherModel.weatherList.first?.main.temp_min ?? 0))\(Constants.TEMPERATURE_ICON)"
        
        if let url = URL(string: Constants.ICON_BASEURL + (weatherModel.weatherList.first?.weather.first?.icon ?? "") + Constants.IMAGE_PNG_EXTENSION) {
            self.iconWeatherType.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.iconWeatherType.sd_setImage(with: url)
        }
    }
}
