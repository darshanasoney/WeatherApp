//
//  Place.swift
//  WeatherApp
//
//  Created by Aubergine on 19/12/24.
//

class Place {
    let name: String
    let lat: Double
    let long: Double
    let fullName : String
    
    init(name: String, lat: Double, long: Double, fullName: String) {
        self.name = name
        self.lat = lat
        self.long = long
        self.fullName = fullName
    }
}
