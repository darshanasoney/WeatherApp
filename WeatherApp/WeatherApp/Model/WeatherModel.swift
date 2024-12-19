//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Aubergine on 19/12/24.
//

import Foundation

struct WeatherModel: Codable, Equatable {
    
    static func == (lhs: WeatherModel, rhs: WeatherModel) -> Bool {
        return lhs.city.id == rhs.city.id
    }
    
    let city : City
    var weatherList: [WeatherList]
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case weatherList = "list"
    }
    
    init(city: City, weatherList: [WeatherList]) {
        self.city = city
        self.weatherList = weatherList
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.city = try container.decode(City.self, forKey: .city)
        self.weatherList = try container.decode([WeatherList].self, forKey: .weatherList)
    }
}
