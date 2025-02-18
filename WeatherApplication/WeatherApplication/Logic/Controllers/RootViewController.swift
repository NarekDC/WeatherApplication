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
    
    private lazy var viewModel: CurrentWeatherViewModel = {
        return CurrentWeatherViewModel()
    }()
         
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        
        return manager
    }()
    
    private var currentLocation: CLLocation? {
        didSet {
            print("current location \(String(describing: currentLocation))")
            updateWeatherData()
        }
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActiveNotification()
    }
    
    private func updateWeatherData() {
        guard let currentLocation = currentLocation else { return }

        viewModel.fetchWeather(currentLocation: currentLocation)
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
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
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
