//
//  weatherListCell.swift
//  WeatherSampleApp
//
//  Created by sunilreddy on 27/05/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import UIKit
import CoreData

class weatherListCell: UITableViewCell {

    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(model : WeatherTable?) {
        guard let modelList = model else {
            return
        }
        self.timeLbl.text = modelList.time ?? ""
        self.titleLbl.text = modelList.cityName
        self.tempLbl.text = "\(Int(round(modelList.temp)))°"
    }
    
}
