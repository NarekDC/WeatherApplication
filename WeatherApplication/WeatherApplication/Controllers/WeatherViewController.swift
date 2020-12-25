//
//  WeatherViewController.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/25/20.
//

import Foundation
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    var userLocation: CLLocation!
    
    var weatherInfo: WeatherInfo?
    let queryService = QueryService()
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentStatus: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var cloud: UILabel!
    @IBOutlet weak var windspeed: UILabel!
    
    @IBOutlet weak var infoTable: UITableView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        navigationItem.title = "Weather Scene"
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        getWeatherDataForDefaultSelectedCity()
        checkIfLocationManagerIsEnabled()
    }

    func getWeatherDataForDefaultSelectedCity() {
        let defaultCity = "London,UK"
        queryService.getCurrentWeather(name: defaultCity, id : nil, location: nil, completion: { weatherInfo, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let weatherInfo = weatherInfo {
                self.weatherInfo = weatherInfo
                DispatchQueue.main.async { [weak self] in
                    //
                }
            }
            if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
        })
    }
    
    func checkIfLocationManagerIsEnabled () {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
            
        @unknown default:
            print("fatal")
        }
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            userLocation = currentLocation
            queryService.getCurrentWeather(name: nil, id: nil, location: userLocation, completion: { weatherInfo, errorMessage in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let weatherInfo = weatherInfo {
                    self.weatherInfo = weatherInfo
                    DispatchQueue.main.async { [weak self] in
                       //
                    }
                }
                if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
            })
            /// todo get forecaseweather.
            print("Current location: \(currentLocation)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
