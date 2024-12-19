//
//  SearchPlaceViewModel.swift
//  WeatherApp
//
//  Created by Aubergine on 19/12/24.
//

import Foundation
import MapKit

class SearchPlaceViewModel {
    
    var arySearchedPlacesList = [Place]()
    var onSearchCompleted: ((Bool, String) -> Void)?
    
    private var delegate: WeatherViewModelProtocol?
    
    init(delegate : WeatherViewModelProtocol) {
        self.delegate = delegate
    }
    
    func searchPlaces(query: String) {
        self.arySearchedPlacesList = []
        if !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() , execute: {
                
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = query
                
                let search = MKLocalSearch(request: request)
                
                search.start { (response, error) in
                    if let error = error {
                        if (error as NSError).code == 4 {
                            DispatchQueue.main.async {
                                self.delegate?.stopLoading()
                                self.onSearchCompleted?(false, "No records available!")
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.delegate?.stopLoading()
                                self.onSearchCompleted?(false, error.localizedDescription)
                            }
                        }
                        return
                    }
                    
                    guard let mapItems = response?.mapItems else {
                        DispatchQueue.main.async {
                            self.delegate?.stopLoading()
                            self.onSearchCompleted?(false, "No results found")
                        }
                        return
                    }
                    
                    let ary = mapItems.compactMap { item in
                        return Place(name: item.name ?? "",
                                     lat: item.placemark.coordinate.latitude,
                                     long: item.placemark.coordinate.longitude,
                                     fullName: item.placemark.title ?? "")
                    }
                    
                    guard ary.count > 0 else {
                        DispatchQueue.main.async {
                            self.delegate?.stopLoading()
                            self.onSearchCompleted?(false, "No results found")
                        }
                        return
                    }
                    
                    self.arySearchedPlacesList = ary
                    DispatchQueue.main.async {
                        self.delegate?.stopLoading()
                        self.onSearchCompleted?(true, "")
                    }
                }
            })
        } else {
            self.onSearchCompleted?(false, "No record found")
        }
    }
}
