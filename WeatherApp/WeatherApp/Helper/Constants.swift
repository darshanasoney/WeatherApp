//
//  Constants.swift
//  WeatherApp
//
//  Created by Aubergine on 18/12/24.
//

import UIKit

class Constants: NSObject {
    
    static let API_KEY = "443384d3416c45463b0ea5aca93ae4c2"
    static let BASEURL = "https://api.openweathermap.org/"
    static let ICON_BASEURL = "https://openweathermap.org/img/wn/"
    
    static let TEMPERATURE_ICON = "\u{00B0}C"
    static let CITY_WEATHER_CELL_IDENTIFIER = "CityWeatherTableViewCell"
    static let CITY_DAY_WEATHER_CELL_IDENTIFIER = "CityDayWeatherTableViewCell"
    static let SEARCH_CITY_CONTROLLER_IDENTIFIER = "SearchCityViewController"
    static let SEARCH_CITY_CELL_IDENTIFIER = "SearchCityTableViewCell"
    static let CITY_WEATHER_DETAILS_CONTROLLER_IDENTIFIER = "WeatherDetailViewController"
    
    static let IMAGE_PNG_EXTENSION = ".png"
    static let SCREEN_MIN_SIZE = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    static let SCREEN_RATIO = CGFloat(SCREEN_MIN_SIZE)/320
}
