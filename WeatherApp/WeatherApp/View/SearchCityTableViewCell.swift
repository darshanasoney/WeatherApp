//
//  SearchCityTableViewCell.swift
//  WeatherApp
//
//  Created by Aubergine on 18/12/24.
//

import UIKit

class SearchCityTableViewCell: UITableViewCell {

    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var labelSearchedCityName: UILabel! {
        didSet{
            guard let label = self.labelSearchedCityName else { return }
            label.font = .appFont(size: 15, weight: .medium)
            label.textColor = UIColor.gray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populate(place: Place) {
        DispatchQueue.main.async {
            self.labelSearchedCityName.text = place.fullName
        }
    }
}
