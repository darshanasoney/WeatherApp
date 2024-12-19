//
//  WeatherDataManager.swift
//  WeatherApp
//
//  Created by Aubergine on 19/12/24.
//

import Foundation

class WeatherDataManager {
    
    static let instsnce = WeatherDataManager()
    
    private init() {}
    
    private let userDefaultsKey = "WeatherModels"
    
    /// Stores an array of WeatherModel to UserDefaults
    func saveWeatherModels(_ models: [WeatherModel]) {
        do {
            let data = try JSONEncoder().encode(models)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to encode weather models: \(error)")
        }
    }
    
    /// Retrieves an array of WeatherModel from UserDefaults
    func retrieveWeatherModels() -> [WeatherModel]? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return nil
        }
        do {
            let models = try JSONDecoder().decode([WeatherModel].self, from: data)
            return models
        } catch {
            print("Failed to decode weather models: \(error)")
            return nil
        }
    }
}

