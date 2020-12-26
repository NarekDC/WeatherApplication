//
//  RootViewController.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/25/20.
//

import Foundation
import UIKit
import CoreLocation

class RootViewController: UIViewController {
    
    let currentWeatherViewController = WeatherViewController.instantiateFromStoryboard()
         
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        
        return manager
    }()
    
    private var currentLocation: CLLocation? {
        didSet {
            fetchCity()
            fetchWeather()
        }
    }
    
    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon, completion: {
            response, error in
            if let error = error {
                dump(error)
            } else if let response = response {
//                self.currentWeatherViewController.viewModel?.weather = response
                // Nofity CurrentWeatherViewController
                print("response \(response)")
            }
        })
    }
    
    private func fetchCity() {
        guard let currentLocation = currentLocation else { return }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {
            placemarks, error in
            if let error = error {
                dump(error)
            }
            else if let city = placemarks?.first?.locality {
                // Notify CurrentWeatherViewController
                let l = Location(
                    name: city,
                    latitude: currentLocation.coordinate.latitude,
                    longitude: currentLocation.coordinate.longitude)
//                self.currentWeatherViewController.viewModel?.location = l
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActiveNotification()
        
//        currentWeatherViewController.viewModel = CurrentWeatherViewModel()
    }
    
    private func setupActiveNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(RootViewController.applicationDidBecomeActive(notification:)),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    
    @objc func applicationDidBecomeActive(notification: Notification) {
        // Request user's location.
        requestLocation()
    }
    
    private func requestLocation() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }

}

extension RootViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        switch manager.authorizationStatus {
            case .authorizedAlways , .authorizedWhenInUse:
                break
            case .notDetermined , .denied , .restricted:
                break
            default:
                break
        }
        
        switch manager.accuracyAuthorization {
            case .fullAccuracy:
                break
            case .reducedAccuracy:
                break
            default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            manager.delegate = nil
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
}
