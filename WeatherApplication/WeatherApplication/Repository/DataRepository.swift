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
        let objects = dbContainer?.values(WeatherInfo.self, matching: nil)
        completion(.success((objects?.first)!))
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
