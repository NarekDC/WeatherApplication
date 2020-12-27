//
//  UrlConfig.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/25/20.
//

import Foundation

// http://api.openweathermap.org/data/2.5/onecall?lat=51.509980&lon=-0.133700&appid=3687e5261eeb79b6aa8c42a493731e9a

enum Key: String {
    case weatherApiKey = "3687e5261eeb79b6aa8c42a493731e9a"
}

struct API {
    static let key = Key.weatherApiKey.rawValue
    static let baseURL = URL(string: "http://api.openweathermap.org/data/2.5/onecall")!
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

struct Global{
    
    static func printToConsole(message : String) {
        #if DEBUG
        print(message)
        #endif
    }
}
