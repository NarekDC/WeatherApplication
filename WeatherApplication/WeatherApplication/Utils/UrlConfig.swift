//
//  UrlConfig.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/25/20.
//

import Foundation

// http://api.openweathermap.org/data/2.5/weather?lat=51.509980&lon=-0.133700&appid=3687e5261eeb79b6aa8c42a493731e9a
// forecast/daily?q={city name}&cnt={cnt}&appid={API key}

enum Key: String {
    case weatherApiKey = "3687e5261eeb79b6aa8c42a493731e9a"
}

struct API {
    static let key = Key.weatherApiKey.rawValue
    static let baseURL = URL(string: "http://api.openweathermap.org/data/2.5/weather")!
}

protocol Endpoint {
    
    var base: String { get }
    var path: String { get }
}

extension Endpoint {
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url,cachePolicy: .reloadIgnoringLocalCacheData)
    }
}

enum WeatherInfoEndpoint {
    
    case current
    case forecast
}

extension WeatherInfoEndpoint: Endpoint {
    
    var base: String {
        return API.baseURL.absoluteString
    }
    
    var path: String {
        switch self {
        case .current: return "/weather"
        case .forecast: return "/forecast/daily"
        }
    }
}

enum MeteoriteRecord {
    
    case listRecords
}

extension MeteoriteRecord: Endpoint {
    
    var base: String {
        return API.baseURL.absoluteString
    }
    
    var path: String {
        switch self {
        case .listRecords: return "/resource/y77d-th95.json"
        }
    }
}




struct Global{
    
    static func printToConsole(message : String) {
        #if DEBUG
        print(message)
        #endif
    }
}

