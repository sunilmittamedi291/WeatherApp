//
//  CityListViewModel.swift
//  WeatherSampleApp
//
//  Created by sunilreddy on 27/05/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import Foundation
import CoreData

class CityListViewModel {
    var shouldUpdateViewState: (_ weatherList: [WeatherTable]?, _ error: String? ) -> Void = { _,_  in }
    var cityModel: WeatherModel?
    var tempCelsius: Double {
        get {
            if let temp = cityModel?.main?.temp {
                return temp - 273.15
            } else {
                return 0
            }
        }
    }
    var fellsLike: Double {
        get {
            if let temp = cityModel?.main?.feelsLike {
                return temp - 273.15
            } else {
                return 0
            }
        }
    }
    var timeString  :String {
        get {
            return cityModel?.dt?.convertTimeStampToTime ?? ""
        }
    }
    var sunRise: String {
        get {
            return cityModel?.sys.sunrise?.convertTimeStampToTime ?? ""
        }
    }
    var sunSet: String {
        get {
            return cityModel?.sys.sunset?.convertTimeStampToTime ?? ""
        }
    }
    func callWeatherDataApi(_ cityName: String) {
        let roomListUrl = Constants.weatherUrl
        let postDict = ["q": cityName, "appid": "66c3fd0cb6de2383542585703136321a"]
        ApiDataManagerClass.shared.commonGetMethodUsingJsonSerialization(urlString: roomListUrl, postBody: postDict) { [weak self]  (data, response, error) in
            guard let jsonData = data else {
                if let weatherModel = self?.fetchWeatherList() {
                    self?.shouldUpdateViewState(weatherModel, nil)
                } else {
                    self?.shouldUpdateViewState(nil, "No Internet Connection")
                }
                return
            }
            let collection = try? JSONDecoder().decode(WeatherModel.self, from: jsonData)
            guard let weatherModel = collection else {
                return
            }
            self?.cityModel = weatherModel
            //Before save we have to check duplicate data
            self?.checkDuplicateDataInPersistence(cityId: weatherModel.id)
            //Save the weather in persistence
            self?.saveContext(jsonModel: weatherModel)
            guard let fetchList = self?.fetchWeatherList() else {
                return
            }
            self?.shouldUpdateViewState(fetchList, nil)
            
            //self?.shouldUpdateViewState(roomData, nil)
        }
    }
    fileprivate func saveContext(jsonModel: WeatherModel) {
        let context = DatabaseController.getContext()
        let roomListModel:WeatherTable = DatabaseController.getEntity(context: context)
        roomListModel.cityName = jsonModel.name
        roomListModel.weatherDesc = jsonModel.weather?.first?.weatherDescription ?? ""
        roomListModel.lat = jsonModel.coord?.lat ?? 0.0
        roomListModel.long = jsonModel.coord?.lon ?? 0.0
        roomListModel.temp = tempCelsius
        roomListModel.time = timeString
        roomListModel.sunRise = sunRise
        roomListModel.sunSet = sunSet
        roomListModel.cityId = Int32(jsonModel.id)
        roomListModel.feelsLike = fellsLike
        DatabaseController.saveContext()
    }
    func fetchWeatherList() -> [WeatherTable]? {
        let context = DatabaseController.getContext()
        let  fetchRequest: NSFetchRequest<WeatherTable> = WeatherTable.fetchRequest()
        let roomList = try? context.fetch(fetchRequest)
        do {
            try context.save()
        } catch {
            
        }
        return roomList
    }
    func checkDuplicateDataInPersistence(cityId: Int) {
        let context = DatabaseController.getContext()
        guard let fetchList = self.fetchWeatherList() else {
            return
        }
        for model in fetchList {
            if model.cityId == cityId {
                print("already exist")
                context.delete(model)
            }
        }
    }
}


