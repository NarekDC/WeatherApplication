//
//  WeatherViewModel.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/26/20.
//

import Foundation
import UIKit

struct CurrentWeatherViewModel {
    
    var isLocationReady = false
    var isWeatherReady = false
    
    var isUpdateReady: Bool {
        return isLocationReady && isWeatherReady
    }
    
    var location: Location! {
        didSet {
            self.isLocationReady = location != nil ? true : false
        }
    }
    
    var weather: WeatherInfo! {
        didSet {
            self.isWeatherReady = weather != nil ? true : false
        }
    }
    
    var city: String {
        return location.name
    }
    
    var temperature: String {
        return String(format: "%.1f °F", 12)
    }
    
}
