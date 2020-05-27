//
//  wetaherDetailesController.swift
//  WeatherSampleApp
//
//  Created by sunilreddy on 27/05/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import UIKit
import CoreData

class weatherDetailesController: UIViewController {
    var weatherDetailModel: WeatherTable?
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var latLbl: UILabel!
    @IBOutlet weak var longLbl: UILabel!
    @IBOutlet weak var fellsLikeLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fillWeatherDetailData()
        // Do any additional setup after loading the view.
    }
    fileprivate func fillWeatherDetailData() {
        guard let model = weatherDetailModel else {
            return
        }
        self.cityNameLbl.text = model.cityName
        self.descriptionLbl.text = model.weatherDesc
        self.latLbl.text = "Lat: \(model.lat)"
        self.longLbl.text = "Long: \(model.long)"
        self.sunriseLbl.text = "Sunrise: \(model.sunRise ?? "")"
        self.sunsetLbl.text = "Sunset: \(model.sunSet ?? "")"
        self.fellsLikeLbl.text = "Feels like: \(Int(round(model.feelsLike)))°"
    }
    
}
