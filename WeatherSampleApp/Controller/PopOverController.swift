//
//  PopOverController.swift
//  CurrencyApp
//
//  Created by sunilreddy on 08/05/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import UIKit

protocol PopOverProtocol:class {
    func sendBackData(_ cityName: String)
}

class PopOverController: UIViewController {
    
    //HardcodedCityListArray
    let cityListArray = ["Mumbai", "Bangalore", "Hyderabad", "Chennai", "Kolkata", "Mysuru", "Pune", "Shivamogga", "Ballari"]
    weak var delegate: PopOverProtocol?
    @IBOutlet weak var popoverTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverTableView.register(UINib(nibName:"PopOverCell", bundle: nil), forCellReuseIdentifier:"PopOverCell")
        
    }
}
extension PopOverController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"PopOverCell", for: indexPath) as? PopOverCell else { return UITableViewCell() }
        cell.textLabel?.text = cityListArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        delegate?.sendBackData(cityListArray[indexPath.row])
    }
    
}
