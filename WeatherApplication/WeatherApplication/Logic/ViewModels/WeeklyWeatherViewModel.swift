//
//  WeeklyWeatherViewModel.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/27/20.
//


import Foundation

enum UserAlert:  String, Error {
    case userError = "Please make sure your network is working fine or re-launch the app"
    case serverError = "Please wait a while and re-launch the app"
}

final class WeeklyWeatherViewModel {
    private var dataRepo: DataRepositoryProtocol
    var meteoriteList = [Daily]()
    private var cellViewModels: [MeteoriteListCellViewModel] = [MeteoriteListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    var isSegueAllowed: Bool = false
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init(dataRepo:DataRepositoryProtocol = DataRepository()) {
        self.dataRepo = dataRepo
    }
    
    func initFetch() {
        self.isLoading = true
        
//        dataRepo.initFetch{ [weak self] result in
//            self?.isLoading = false
//            
//            switch result{
//            case .success(let meteorites):
//                self?.processMeteoriteToCellModel(meteorites: meteorites)
//            case .failure(let error):
//                self?.processError(error: error)
//            }
//        }
    }
    
    private func processError(error:DataManagerError) {
        Global.printToConsole(message: error.localizedDescription)
    }
    
    private func processMeteoriteToCellModel(weatherInfo: WeatherInfo) {
        
//        self.meteoriteList = weatherInfo.daily
        self.cellViewModels = self.meteoriteList.map { createCellViewModel(daily: $0) }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> MeteoriteListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(daily:Daily) -> MeteoriteListCellViewModel {
        let meteoriteMass = "UNKNOWN"
        let meteoriteDate = "UNKNOWN"
        let temp = "\(daily.temp)"
        
        return MeteoriteListCellViewModel(  titleText: temp,
                                            sizeText: meteoriteMass,
                                            dateText: meteoriteDate )
    }
}


struct MeteoriteListCellViewModel {
    let titleText: String
    let sizeText: String
    let dateText: String
}
