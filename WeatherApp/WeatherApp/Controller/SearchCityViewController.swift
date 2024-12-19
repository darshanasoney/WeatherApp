//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Aubergine on 19/12/24.
//

import UIKit

class SearchCityViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelNoRecordsFound: UILabel! {
        didSet{
            guard let label = self.labelNoRecordsFound else { return }
            label.font = .appFont(size: 18, weight: .medium)
            label.textColor = UIColor.gray
        }
    }
    
    @IBOutlet weak var btnCancel: UIButton! {
        didSet{
            guard let button = self.btnCancel else { return }
            button.tintColor = UIColor.lightGray
        }
    }
    
    @IBOutlet weak var tableCityList: UITableView!
    
    private var viewModel : SearchPlaceViewModel?
    var onPlaceSelected : ((Place) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupObservers()
    }
    
    func setupUI() {
        self.searchBar.delegate = self
        self.searchBar.searchTextField.becomeFirstResponder()
        self.tableCityList.delegate = self
        self.tableCityList.dataSource = self
        self.tableCityList.register(UINib(nibName: Constants.SEARCH_CITY_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: Constants.SEARCH_CITY_CELL_IDENTIFIER)
    }
    
    func setupObservers() {
        viewModel = SearchPlaceViewModel(delegate: self)
        
        self.viewModel?.onSearchCompleted = { [weak self] isDataAvailable, error in
            
            guard let `self` = self else { return }
            self.loadSearchView(isDataAvailable:isDataAvailable, error: error)
        }
    }
    
    private func loadSearchView(isDataAvailable : Bool, error : String = "") {
        
        self.labelNoRecordsFound.isHidden = isDataAvailable
        self.tableCityList.isHidden = !isDataAvailable
        
        if isDataAvailable {
            self.tableCityList.reloadData()
        } else {
            self.labelNoRecordsFound.text = error
        }
    }
}

extension SearchCityViewController {
    
    @IBAction func btnCancelSearchPressed(_ btn : UIButton) {
        self.dismiss(animated: true)
    }
}

extension SearchCityViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.arySearchedPlacesList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.SEARCH_CITY_CELL_IDENTIFIER) as? SearchCityTableViewCell else {
            return UITableViewCell()
        }
        
        guard self.viewModel?.arySearchedPlacesList.count ?? 0 > 0 else {
            return UITableViewCell()
        }
        
        guard let place = self.viewModel?.arySearchedPlacesList[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.populate(place: place)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let place = self.viewModel?.arySearchedPlacesList[indexPath.row] {
            self.dismiss(animated: true) {
                self.onPlaceSelected?(place)
            }
        }
    }
}

extension SearchCityViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchPlaces(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        viewModel?.searchPlaces(query: searchBar.text ?? "")
    }
}

//MARK: SearchCityViewController Delegates Methods

extension SearchCityViewController : WeatherViewModelProtocol {
    func startLoading() {
        self.view.activityStartAnimating()
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.view.activityStopAnimating()
        }
    }
}

extension SearchCityViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
