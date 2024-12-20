//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Aubergine on 18/12/24.
//

import XCTest

@testable import WeatherApp

class WeatherServicesTests: XCTestCase {
    
    var weatherServices: WeatherServices!
    var mockURLSession: URLSessionMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockURLSession = URLSessionMock()
        weatherServices = WeatherServices.instance
    }
    
    override func tearDownWithError() throws {
        weatherServices = nil
        mockURLSession = nil
        try super.tearDownWithError()
    }
    
        func test_fetchWeatherData_successfulResponse_returnsWeatherModel() {
        // Arrange
        let mockWeatherData = """
        {
            "weather": [
                { "id": 800, "main": "Clear", "description": "clear sky", "icon": "01d" }
            ],
            "main": { "temp": 28.55, "feels_like": 30.11, "temp_min": 28.55, "temp_max": 28.55, "pressure": 1012, "humidity": 74 }
        }
        """.data(using: .utf8)!
        
        mockURLSession.data = mockWeatherData
        mockURLSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let expectation = self.expectation(description: "Weather data should be successfully decoded and returned")
        
        // Act
        weatherServices.fetchWeatherData(lat: 12.9716, long: 77.5946) { result in
            switch result {
            case .success(let weatherModel):
                XCTAssertNotNil(weatherModel, "Weather model should not be nil")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchWeatherData_noDataResponse_returnsNoDataError() {
        // Arrange
        mockURLSession.data = nil
        
        let expectation = self.expectation(description: "No data should return noData error")
        
        // Act
        weatherServices.fetchWeatherData(lat: 0.9716, long: 77567.5946) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, .noData, "Expected .noData, but got \(error)")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 4.0)
    }
    
    func test_fetchWeatherData_networkError_returnsNoNetworkError() {
        // Arrange
        let networkError = NSError(domain: "Network", code: -1009, userInfo: nil)
        mockURLSession.error = networkError
        
        let expectation = self.expectation(description: "Network error should return noNetwork error")
        
        // Act
        weatherServices.fetchWeatherData(lat: 12.9716, long: 77.5946) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, .noNetwork(networkError), "Expected .noNetwork, but got \(error)")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchWeatherData_parseError_returnsParseError() {
        // Arrange
        let invalidJSONData = "invalid json data".data(using: .utf8)!
        mockURLSession.data = invalidJSONData
        
        let expectation = self.expectation(description: "Invalid JSON data should return parseError")
        
        // Act
        weatherServices.fetchWeatherData(lat: 0, long: 77.5946) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                if case .parseError = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected .parseError, but got \(error)")
                }
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

class URLSessionMock: URLSession, @unchecked Sendable {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskMock()
        task.completionHandler = {
            completionHandler(self.data, self.response, self.error)
        }
        return task
    }
}

class URLSessionDataTaskMock: URLSessionDataTask, @unchecked Sendable {
    var completionHandler: (() -> Void)?
    
    override func resume() {
        completionHandler?()
    }
}
