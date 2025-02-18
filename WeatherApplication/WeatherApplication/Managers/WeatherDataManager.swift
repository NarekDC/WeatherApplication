//
//  WeatherDataManager.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/26/20.
//

import Foundation

enum DataManagerError: Error {
    case failedRequest
    case invalidResponse
    case unknown
}

final class WeatherDataManager {
    internal let baseURL: URL
    
    internal init(baseURL: URL) {
        self.baseURL = baseURL
    }

    static let shared = WeatherDataManager(baseURL: API.baseURL)
    
    typealias CompletionHandler = (WeatherInfo?, DataManagerError?) -> Void
    
    func weatherDataAt(latitude: Double, longitude: Double, completion: @escaping CompletionHandler) {
        
        let weatherApiUrl = baseURL.absoluteString
        
        if var urlComponents = URLComponents(string: weatherApiUrl) {
            urlComponents.query = "lat=\(latitude)&lon=\(longitude)"
                + "&appid=\(API.key)" + "&units=metric"
            
            guard let url = urlComponents.url else { return }
           
            var request = URLRequest(url: url)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                self.didFinishGettingWeatherData(data: data, response: response, error: error, completion: completion)
            }).resume()
        }
    }
    
    func didFinishGettingWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: CompletionHandler) {
        if let _ = error {
            completion(nil, .failedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let weatherData = try decoder.decode(WeatherInfo.self, from: data)
                    completion(weatherData, nil)
                } catch {
                    completion(nil, .invalidResponse)
                }
            } else {
                completion(nil, .failedRequest)
            }
        } else {
            completion(nil, .unknown)
        }
    }
}

