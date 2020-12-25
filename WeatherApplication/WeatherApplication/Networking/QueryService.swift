//
//  QueryService.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/25/20.
//

import Foundation
import CoreLocation

class QueryService {

  typealias JSONDictionary = [String: Any]
  typealias WeatherResult =  (WeatherInfo?, String) -> ()

  let defaultSession = URLSession(configuration: .default)
  var dataTask: URLSessionDataTask?
  var weatherInfo: WeatherInfo?
  var errorMessage = ""
    
    func getCurrentWeather(name:String?, id:String?, location: CLLocation?, completion: @escaping WeatherResult ) {
    dataTask?.cancel()
    if var urlComponents = URLComponents(string: weatherApiUrl) {
        if let location = location {
            urlComponents.query = "lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
                + "&appid=\(weatherApiKey)" + "&units=metric"
        }
        if let name = name {
            urlComponents.query = "q=\(name)" + "&appid=\(weatherApiKey)" + "&units=metric"
        }
        if let id = id {
            urlComponents.query = "id=\(id)" + "&appid=\(weatherApiKey)" + "&units=metric"
        }
        
        guard let url = urlComponents.url else { return }
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                print(self.errorMessage)
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self.updateWeather(data)
                DispatchQueue.main.async {
                    completion(self.weatherInfo, self.errorMessage)
                }
            }
        }
        dataTask?.resume()
    }
  }
    
    fileprivate func updateWeather(_ data: Data) {
        weatherInfo = nil

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .customISO8601
            let weatherInfoModel = try decoder.decode(WeatherInfo.self, from:
                data)
        weatherInfo = weatherInfoModel
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
}
