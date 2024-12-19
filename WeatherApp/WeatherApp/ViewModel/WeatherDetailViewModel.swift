//
//  WeatherListViewModel.swift
//  WeatherApp
//
//  Created by Aubergine on 19/12/24.
//

import Foundation


class WeatherDetailViewModel {
    
    var weatherDetails : WeatherModel?
    var onListPrepared: ((Bool) -> Void)?
    
    var weatherList : [WeatherList]?
    
    init(weatherDetails: WeatherModel? = nil, onListPrepared: ( (Bool) -> Void)? = nil) {
        self.weatherDetails = weatherDetails
        self.onListPrepared = onListPrepared
    }
    
    func sortWeatherData() {
        self.weatherList = self.getDailyWeatherSummary()
        self.onListPrepared?(true)
    }
    
    func getDailyWeatherSummary() -> [WeatherList] {
        var dailyWeatherData: [String: [WeatherList]] = [:]
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        for weather in self.weatherDetails?.weatherList ?? [] {
            let date = Date(timeIntervalSince1970: TimeInterval(weather.date))
                let day = dayFormatter.string(from: date)
                dailyWeatherData[day, default: []].append(weather)
        }
        var weatherResult: [WeatherList] = []
        
        for (_, weatherArray) in dailyWeatherData {
            let minTemp = weatherArray.map { $0.main.temp_min }.min() ?? 0.0
            let maxTemp = weatherArray.map { $0.main.temp_max }.max() ?? 0.0
            
            let mainInfo = MainInfo(humidity: weatherArray.first?.main.humidity ?? 0,
                                    temp_min: minTemp,
                                    temp_max: maxTemp,
                                    temp: weatherArray.first?.main.temp ?? 0)
            
            let dailyWeather = WeatherList(date: weatherArray.first?.date ?? 0,
                                      dateInString: weatherArray.first?.dateInString ?? "",
                                      main: mainInfo,
                                      weather: weatherArray.first?.weather ?? [])
        
            weatherResult.append(dailyWeather)
        }
        weatherResult.sort { $0.date < $1.date }
        
        return weatherResult
    }
                                                  
}
