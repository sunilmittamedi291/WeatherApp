//
//  Extension.swift
//  WeatherSampleApp
//
//  Created by sunilreddy on 27/05/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import Foundation
import  UIKit

extension Int {
    var convertToDate: Date? {
        
        let dateTimeStamp = Date(timeIntervalSince1970: TimeInterval(self) / 1000)
        
        return dateTimeStamp
    }
    var convertTimeStampToTime: String? {
        let dateTimeStamp = Date(timeIntervalSince1970: TimeInterval(self) )
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat =  "hh:mm a"
        let result = dateFormatter.string(from: dateTimeStamp as Date)
        return result
    }
    var convertTimeStampToDateAndTime: String? {
        let dateTimeStamp = NSDate(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat =  "dd MMM hh:mm a"
        let result = dateFormatter.string(from: dateTimeStamp as Date)
        return result
    }
}
extension UIViewController {
    func showAlertView(withTitle title: String, withErrorMessage message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
