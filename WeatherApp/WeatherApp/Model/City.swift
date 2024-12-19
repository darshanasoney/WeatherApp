//
//  City.swift
//  WeatherApp
//
//  Created by Aubergine on 19/12/24.
//

import Foundation

struct City: Codable, Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }
    
    let sunset : Double
    let country: String
    let id: Int
    let coord: Cordinate
    let timezone: Double
    let sunrise: Double
    let name : String
    
    init(sunset: Double, country: String, id: Int, coord: Cordinate, timezone: Double, sunrise: Double, name: String) {
        self.sunset = sunset
        self.country = country
        self.id = id
        self.coord = coord
        self.timezone = timezone
        self.sunrise = sunrise
        self.name = name
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sunset = try container.decode(Double.self, forKey: .sunset)
        self.country = try container.decode(String.self, forKey: .country)
        self.id = try container.decode(Int.self, forKey: .id)
        self.coord = try container.decode(Cordinate.self, forKey: .coord)
        self.timezone = try container.decode(Double.self, forKey: .timezone)
        self.sunrise = try container.decode(Double.self, forKey: .sunrise)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

struct Cordinate: Codable {
    let lat : Double
    let lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
    }
}
