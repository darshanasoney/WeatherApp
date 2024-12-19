//
//  WeatherListViewModel.swift
//  WeatherApp
//
//  Created by Aubergine on 19/12/24.
//

import Foundation

protocol WeatherViewModelProtocol {
    func startLoading()
    func stopLoading()
}

class WeatherListViewModel {
    
    var weatherData = [WeatherModel]()
    
    var onListPrepared: ((Bool) -> Void)?
    var onErrorOccurred: ((Error) -> Void)?
    
    private var delegate: WeatherViewModelProtocol?
    
    init(delegate : WeatherViewModelProtocol) {
        self.delegate = delegate
    }
    
    func retrieveWeatherData() {
        self.delegate?.startLoading()
        if let weatherInfo = WeatherDataManager.instsnce.retrieveWeatherModels() {
            self.weatherData = weatherInfo
            self.delegate?.stopLoading()
            self.onListPrepared?(true)
        } else {
            self.delegate?.stopLoading()
            self.onListPrepared?(false)
        }
    }
    
    func fetchWeatherData(place: Place) {
        self.delegate?.startLoading()
        WeatherServices.instance.fetchWeatherData(lat: place.lat, long: place.long, completionHandler: { [weak self] result in
            
            guard let `self` = self else { return }
            
            switch result {
            case .failure(let error):
                self.delegate?.stopLoading()
                onErrorOccurred?(error)
                break
                
            case .success(let weatherData):
                self.weatherData.append(weatherData)
                self.weatherData.reverse()
                WeatherDataManager.instsnce.saveWeatherModels(self.weatherData)
                self.delegate?.stopLoading()
                onListPrepared?(true)
                break
            }
        })
    }
}
