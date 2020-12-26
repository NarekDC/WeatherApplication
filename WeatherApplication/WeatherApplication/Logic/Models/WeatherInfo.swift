//
//  WeatherInfo.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/25/20.
//

import Foundation

struct WeatherInfo: Codable {
    let coord: WeatherCoord
    let sys: WeatherSys
    let weather: [WeatherWeather]
    let main: Main
    let wind: WeatherWind
    let clouds: WeatherClouds
    let dt, id: Int
    let name: String
    let cod: Int
}

struct WeatherClouds: Codable {
    let all: Int
}

struct WeatherCoord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp: Double
    let humidity, pressure: Int
    let tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity, pressure
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct WeatherSys: Codable {
    let country: String
    let sunrise, sunset: Int
}

struct WeatherWeather: Codable {
    let id: Int
    let main, description, icon: String
}

struct WeatherWind: Codable {
    let speed, deg: Double
}
