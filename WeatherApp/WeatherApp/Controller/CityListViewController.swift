//
//  CityListViewController.swift
//  WeatherApp
//
//  Created by Aubergine on 18/12/24.
//

import UIKit

class CityListViewController: UIViewController {

    @IBOutlet weak var tableCityList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelNoRecordsFound: UILabel! {
        didSet{
            guard let label = self.labelNoRecordsFound else { return }
            label.font = .appFont(size: 18, weight: .medium)
            label.textColor = UIColor.lightGray
        }
    }
    
    private var viewModel : WeatherListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupObservers()
        self.getCitiesInfo()
    }
    
    func setupUI() {
        self.searchBar.delegate = self
        self.tableCityList.delegate = self
        self.tableCityList.dataSource = self
        self.tableCityList.register(UINib(nibName: Constants.CITY_WEATHER_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: Constants.CITY_WEATHER_CELL_IDENTIFIER)
    }
    
    func setupObservers() {
        viewModel = WeatherListViewModel(delegate: self)
        
        self.viewModel?.onListPrepared = { [weak self] isDataAvailable in
            
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.labelNoRecordsFound.isHidden = isDataAvailable
                self.tableCityList.isHidden = !isDataAvailable
                self.tableCityList.reloadData()
            }
        }
    }
    
    private func getCitiesInfo() {
        guard let viewModel = viewModel else { return }
        viewModel.retrieveWeatherData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension CityListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.weatherData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CITY_WEATHER_CELL_IDENTIFIER) as? CityWeatherTableViewCell else {
            return UITableViewCell()
        }
        
        guard let weatherModel = self.viewModel?.weatherData[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.populate(weatherModel: weatherModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let weatherData = self.viewModel?.weatherData[indexPath.row] {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.CITY_WEATHER_DETAILS_CONTROLLER_IDENTIFIER) as? WeatherDetailViewController{
                vc.viewModel = WeatherDetailViewModel(weatherDetails: weatherData)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
}

//MARK: CityListViewController Delegates Methods

extension CityListViewController : WeatherViewModelProtocol {
    func startLoading() {
        self.view.activityStartAnimating()
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.view.activityStopAnimating()
        }
    }
}

extension CityListViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let vc = self.storyboard?.instantiateViewController(identifier: Constants.SEARCH_CITY_CONTROLLER_IDENTIFIER) as? SearchCityViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            
            vc.onPlaceSelected = { [weak self] place in
                guard let `self` = self else { return }
                
                self.viewModel?.fetchWeatherData(place: place)
            }
            self.present(vc, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let vc = self.storyboard?.instantiateViewController(identifier: Constants.SEARCH_CITY_CONTROLLER_IDENTIFIER) as? SearchCityViewController {
            self.present(vc, animated: true)
        }
    }
}
