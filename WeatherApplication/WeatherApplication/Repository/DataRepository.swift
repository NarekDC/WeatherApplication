//
//  DataRepository.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/26/20.
//

import Foundation
import RealmSwift
import Realm


// 1
//protocol DataRepositoryProtocol {
//    func initFetch(complete completion: @escaping (Result<WeatherInfo, APIError>) -> Void)
//}
//
//class DataRepository {
//    
//    var fetchData: (() -> ())?
//    //  2
//    private let apiClient: WeatherDataManager
//    //  3
//    private var dbContainer: Container?
//    
//    init() {
//        // 4
//        self.apiClient = WeatherDataManager()
//        do {
//            self.dbContainer = try Container()
//        } catch let error {
//            Global.printToConsole(message: error.localizedDescription)
//        }
//    }
//    // 5
//    private func saveToDB(_ meteorites: [APIMeteorite]) {
//        
//        do {
//            try dbContainer?.write { transaction in
//                //TODO: Too much CPU, 13% CPU incraesed
//                meteorites.forEach { item in
//                    transaction.add(item, update: .modified)
//                }
//            }
//        } catch (let error) {
//            Global.printToConsole(message: error.localizedDescription)
//        }
//    }
//    // 5
//    private func getDbInfo(complete completion: @escaping (Result<[Meteorite], APIError>) -> Void) {
//        
//        let results = dbContainer?.values(
//            APIMeteorite.self,
//            matching:nil
//        )
//        completion(.success(results?.filter { $0.geolocation != nil } ?? []))
//    }
//}
//
//extension DataRepository:DataRepositoryProtocol {
//
//    func initFetch(complete completion: @escaping (Result<[Meteorite], APIError>) -> Void) {
//        // 6
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
//}
