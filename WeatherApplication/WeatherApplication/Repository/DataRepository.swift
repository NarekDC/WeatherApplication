//
//  DataRepository.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/26/20.
//

import Foundation


protocol DataRepositoryProtocol {

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
    
    private func saveToDB(_ weatherInfo: WeatherInfo) {
        
        do {
            try dbContainer?.write { transaction in
                transaction.add(weatherInfo, update: .modified)
            }
        } catch (let error) {
            Global.printToConsole(message: error.localizedDescription)
        }
    }
    
    private func getDbInfo(complete completion: @escaping (Result<WeatherInfo, DataManagerError>) -> Void) {
        
//        let object = dbContainer?.values(WeatherInfo.self, matching: nil)
//        completion(.success(object), nil)
    }
}

extension DataRepository:DataRepositoryProtocol {
    
    func initWeatherDataFetch(complete completion: @escaping (Result<WeatherInfo, DataManagerError>) -> Void) {
      
    }
    
//    func initFetch(complete completion: @escaping (Result<[Meteorite], APIError>) -> Void) {
//        
//        
//        
//        apiClient.getListInfo(from: .listRecords) { [weak self] result in
//            switch result{
//                
//            case .success(let meteorites):
//                completion(.success(meteorites))
//                DispatchQueue.main.async {
//                    self?.saveToDB(meteorites)
//                }
//                
//            case .failure(let error):
//                completion(.failure(error))
//                DispatchQueue.main.async {
//                    self?.getDbInfo{ result in
//                        completion(.success( try! result.get()))
//                    }
//                }
//            }
//        }
//    }
}
