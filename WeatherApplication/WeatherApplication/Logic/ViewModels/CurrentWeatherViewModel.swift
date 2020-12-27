//
//  WeatherViewModel.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/26/20.
//

import Foundation
import UIKit
import CoreLocation


struct CurrentWeatherViewModel {    
    private var dataRepo: DataRepositoryProtocol

    init(dataRepo:DataRepositoryProtocol = DataRepository()) {
        self.dataRepo = dataRepo
    }
    
    public mutating func fetchWeather(currentLocation: CLLocation) {
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
                
        WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon, completion: {
            response, error in
            if let error = error {
                dump(error)
            } else if let response = response {
//                self.currentWeatherViewController.viewModel?.weather = response
                // Nofity CurrentWeatherViewController
                print("daily \(response.daily)")
            }
        })
    }
}
