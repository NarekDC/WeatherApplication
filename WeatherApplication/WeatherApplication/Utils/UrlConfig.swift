//
//  UrlConfig.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/25/20.
//

import Foundation

// http://api.openweathermap.org/data/2.5/weather?lat=51.509980&lon=-0.133700&appid=3687e5261eeb79b6aa8c42a493731e9a

enum Key: String {
    case weatherApiKey = "3687e5261eeb79b6aa8c42a493731e9a"
}

struct API {
    static let key = Key.weatherApiKey.rawValue
    static let baseURL = URL(string: "http://api.openweathermap.org/data/2.5/weather")!
}
