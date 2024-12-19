//
//  UIView-Extension.swift
//  WeatherApp
//
//  Created by Aubergine on 19/12/24.
//

import UIKit

class CommonDateFormatter {
    class func getDayFromTimeStamp(timeStamp: Int) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
        
    }
    
    class func getFullDateFromTimeStamp(timeStamp: Int) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy E"
        return dateFormatter.string(from: date)
        
    }
}
