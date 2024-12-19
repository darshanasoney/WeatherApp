//
//  WeatherList.swift
//  WeatherApp
//
//  Created by Aubergine on 19/12/24.
//

import Foundation

struct WeatherList: Codable {
    let date : Int
    let dateInString: String
    let main: MainInfo
    let weather: [WeatherInfo]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case dateInString = "dt_txt"
        case main = "main"
        case weather = "weather"
    }
    
    init(date: Int, dateInString: String, main: MainInfo, weather: [WeatherInfo]) {
        self.date = date
        self.dateInString = dateInString
        self.main = main
        self.weather = weather
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Int.self, forKey: .date)
        self.dateInString = try container.decode(String.self, forKey: .dateInString)
        self.main = try container.decode(MainInfo.self, forKey: .main)
        self.weather = try container.decode([WeatherInfo].self, forKey: .weather)
    }
}

struct WeatherInfo: Codable {
    let main : String
    let icon : String
    let weatherDescription : String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case main = "main"
        case icon = "icon"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.main = try container.decode(String.self, forKey: .main)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.weatherDescription = try container.decode(String.self, forKey: .weatherDescription)
    }
}

struct MainInfo: Codable {
    let humidity : Int
    let temp_min: Double
    let temp_max: Double
    let temp: Double
    
    init(humidity: Int, temp_min: Double, temp_max: Double, temp: Double) {
        self.humidity = humidity
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.temp = temp
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.temp_min = try container.decode(Double.self, forKey: .temp_min)
        self.temp_max = try container.decode(Double.self, forKey: .temp_max)
        self.temp = try container.decode(Double.self, forKey: .temp)
    }
}
