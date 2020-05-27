//
//  ViewController.swift
//  WeatherSampleApp
//
//  Created by sunilreddy on 27/05/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces

class ViewController: UIViewController {
    @IBOutlet weak var listTableview: UITableView!
    let viewModel = CityListViewModel()
    var weatherList: [WeatherTable]? = [] {
        didSet {
            listTableview.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableview.register(UINib(nibName: "weatherListCell", bundle: nil), forCellReuseIdentifier: "weatherListCell")
        fetchWeatherDataFromDb()
        // Do any additional setup after loading the view.
        viewModel.shouldUpdateViewState = { [weak self] (model, error) in
            self?.removeSpinner()
            guard  error == nil  else {
                 self?.showAlertView(withTitle: "Alert", withErrorMessage: error ?? "")
                return
            }
            DispatchQueue.main.async {
                self?.weatherList = model
            }
            
        }
    }
    fileprivate func fetchWeatherDataFromDb() {
        if let modelList =  viewModel.fetchWeatherList() {
            self.weatherList = modelList
        }
    }
    
    @IBAction func plusButton(_ sender: UIButton) {
        print("Plus Button")
        self.popoverMethod(sender: sender)
        //callGooglePlacesApi()
        
    }
    private func callGooglePlacesApi() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        
    }
    private func popoverMethod(sender: UIButton) {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "PopOverController") as? PopOverController else { return }
        popVC.modalPresentationStyle = .popover
        popVC.delegate = self
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = sender
        popOverVC?.sourceRect = CGRect(x: sender.frame.origin.x, y: sender.bounds.minY + 30, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 300)
        self.present(popVC, animated: true)
    }
    
}

extension ViewController: PopOverProtocol {
    func sendBackData(_ cityName: String) {
        guard Reachability.isConnectedToNetwork()  else {
            self.showAlertView(withTitle: "Alert", withErrorMessage: "No Internet Connection")
            return
        }
        self.showSpinner(onView: self.view)
        viewModel.callWeatherDataApi(cityName)
    }
    
}
extension ViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherListCell", for: indexPath) as? weatherListCell else { return UITableViewCell() }
        cell.config(model : weatherList?[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //weather listController
        guard let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "wetaherDetailesController") as? weatherDetailesController else { return  }
        controller.weatherDetailModel = weatherList?[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: false)
        
    }
    
}
extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
