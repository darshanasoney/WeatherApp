//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Aubergine on 18/12/24.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var tableWeatherList: UITableView!
    
    @IBOutlet weak var labelPlaceName: UILabel! {
        didSet{
            guard let label = self.labelPlaceName else { return }
            label.font = .appFont(size: 35, weight: .medium)
            label.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var labelCurrentDate: UILabel! {
        didSet{
            guard let label = self.labelCurrentDate else { return }
            label.font = .appFont(size: 15, weight: .medium)
            label.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var labelTemperature: UILabel! {
        didSet{
            guard let label = self.labelTemperature else { return }
            label.font = .appFont(size: 36, weight: .medium)
            label.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var labelweather: UILabel! {
        didSet{
            guard let label = self.labelweather else { return }
            label.font = .appFont(size: 16, weight: .medium)
            label.textColor = UIColor.lightGray
        }
    }
    
    @IBOutlet weak var labelHumidity: UILabel! {
        didSet{
            guard let label = self.labelHumidity else { return }
            label.font = .appFont(size: 15, weight: .medium)
            label.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var labelHighLowTemperature: UILabel! {
        didSet{
            guard let label = self.labelHighLowTemperature else { return }
            label.font = .appFont(size: 18, weight: .medium)
            label.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var btnCancel: UIButton! {
        didSet{
            guard let button = self.btnCancel else { return }
            button.tintColor = UIColor.lightGray
        }
    }
    var viewModel : WeatherDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupObservers()
    }
    
    func setupObservers() {
        guard let viewModel = self.viewModel else {
            return
        }
        viewModel.onListPrepared = { [weak self] isDataAvailable in
            
            guard let `self` = self else { return }
            self.setupUI()
        }
        viewModel.sortWeatherData()
    }
    
    func setupUI() {
        
        self.tableWeatherList.delegate = self
        self.tableWeatherList.dataSource = self
        self.tableWeatherList.register(UINib(nibName: Constants.CITY_DAY_WEATHER_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: Constants.CITY_DAY_WEATHER_CELL_IDENTIFIER)
    
        if let weatherModel = self.viewModel?.weatherDetails {
            
            self.labelCurrentDate.text = CommonDateFormatter.getFullDateFromTimeStamp(timeStamp: weatherModel.weatherList.first?.date ?? 0)
            self.labelPlaceName.text = weatherModel.city.name
            self.labelweather.text = weatherModel.weatherList.first?.weather.first?.weatherDescription
            self.labelTemperature.text = "\(Int(weatherModel.weatherList.first?.main.temp ?? 0))\(Constants.TEMPERATURE_ICON)"
            self.labelHighLowTemperature.text = "H:\(Int(weatherModel.weatherList.first?.main.temp_max ?? 0))\(Constants.TEMPERATURE_ICON)  L:\(Int(weatherModel.weatherList.first?.main.temp_min ?? 0))\(Constants.TEMPERATURE_ICON)"
            self.labelHumidity.text = "Humidity: \(weatherModel.weatherList.first?.main.humidity ?? 0)"
        }
    }
    
    @IBAction func btnCancelSearchPressed(_ btn : UIButton) {
        self.dismiss(animated: true)
    }
}

extension WeatherDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.weatherList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CITY_DAY_WEATHER_CELL_IDENTIFIER) as? CityDayWeatherTableViewCell else {
            return UITableViewCell()
        }
        guard let weatherModel = self.viewModel?.weatherList?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.populate(weatherModel: weatherModel)
        return cell
    }
    
}

//MARK: WeatherDetailViewController Delegates Methods

extension WeatherDetailViewController : WeatherViewModelProtocol {
    func startLoading() {
        DispatchQueue.main.async {
            self.view.activityStartAnimating()
        }
    }
    func stopLoading() {
        DispatchQueue.main.async {
            self.view.activityStopAnimating()
        }
    }
}
