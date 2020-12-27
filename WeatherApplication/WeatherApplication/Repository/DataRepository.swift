//
//  DataRepository.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/26/20.
//

import Foundation


protocol DataRepositoryProtocol {
    func getDBDataInfo(complete completion: @escaping (Result<WeatherInfo, DataManagerError>) -> Void)
    func saveDataToDB(_ weatherInfo: WeatherInfo)
}

class DataRepository {
    
    var fetchData: (() -> ())?
    
    private let apiClient: WeatherDataManager
    private var dbContainer: Container?
    
    init() {
        
        self.apiClient = WeatherDataManager.shared
        do {
            self.dbContainer = try Container()
        } catch let error {
            Global.printToConsole(message: error.localizedDescription)
        }
    }
    
    func saveToDB(_ weatherInfo: WeatherInfo) {
        
        do {
            try dbContainer?.write { transaction in
                print("weatherInfo in save \(weatherInfo)")
                transaction.add(weatherInfo, update: .modified)
            }
        } catch (let error) {
            Global.printToConsole(message: error.localizedDescription)
        }
    }
    
    func getDbInfo(complete completion: @escaping (Result<WeatherInfo, DataManagerError>) -> Void) {
        let mockWeatherData = WeatherInfo(timezone: "Yerevan", current: Current(sunrise: 0, sunset: 0, temp: 0, pressure: 0, humidity: 0, clouds: 0, windSpeed: 0), daily: [Daily(dt: 131121212, temp: Temp(day: 10, night: 10))])
        let objects = dbContainer?.values(WeatherInfo.self, matching: nil)
        completion(.success((objects?.first ?? mockWeatherData)))
    }
}

extension DataRepository:DataRepositoryProtocol {
    
    func saveDataToDB(_ weatherInfo: WeatherInfo) {
        self.saveToDB(weatherInfo)
    }
    
    func getDBDataInfo(complete completion: @escaping (Result<WeatherInfo, DataManagerError>) -> Void) {
        DispatchQueue.main.async {
            self.getDbInfo{ result in
                completion(.success( try! result.get()))
            }
        }
    }
}
