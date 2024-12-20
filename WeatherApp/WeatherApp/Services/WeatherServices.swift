//
//  WeatherServices.swift
//  WeatherApp
//
//  Created by Aubergine on 19/12/24.
//

import Foundation

typealias completionHandler<T: Encodable> = (Result<T, APIError>) -> Void

enum APIError: Error, Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
    
    case invalidRequest
    case noData
    case invalidData
    case noNetwork(Error)
    case parseError(Error)
}

class WeatherServices {
    
    public static let instance = WeatherServices()
    
    private init() { }
    
    private let weatherDetails = "data/2.5/forecast?"
    
    func fetchWeatherData(lat: Double, long: Double, completionHandler: @escaping completionHandler<WeatherModel>) {
        
        let urlPath = "\(Constants.BASEURL)\(weatherDetails)lat=\(lat)&lon=\(long)&appid=\(Constants.API_KEY)&units=metric"
        
        guard let url = URL(string: urlPath) else {
            completionHandler(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(.noNetwork(error)))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            guard let code = (response as? HTTPURLResponse)?.statusCode, code == 200 else {
                completionHandler(.failure(.noData))
                return
            }
            
            do {
                let weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                
                completionHandler(.success(weatherModel))
                
            } catch {
                completionHandler(.failure(.parseError(error)))
            }
        }
        task.resume()
    }
}
