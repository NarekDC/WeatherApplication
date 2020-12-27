//
//  WeeklyWeatherViewModel.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/27/20.
//


import Foundation

final class WeeklyWeatherViewModel {
    
    private var dataRepo: DataRepositoryProtocol
    var meteoriteList = [Daily]()
    
    private var cellViewModels: [WeeklyWeatherListCellViewModel] = [WeeklyWeatherListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    var reloadTableViewClosure: (()->())?
    
    init(dataRepo:DataRepositoryProtocol = DataRepository()) {
        self.dataRepo = dataRepo
    }
    
    func initFetch() {
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
        
        self.meteoriteList = weatherInfo.daily
        self.cellViewModels = self.meteoriteList.map { createCellViewModel(daily: $0) }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> WeeklyWeatherListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(daily:Daily) -> WeeklyWeatherListCellViewModel {
        let meteoriteMass = "UNKNOWN"
        let meteoriteDate = "UNKNOWN"
        let temp = "\(daily.temp)"
        
        return WeeklyWeatherListCellViewModel(  titleText: temp,
                                            sizeText: meteoriteMass,
                                            dateText: meteoriteDate )
    }
}


struct WeeklyWeatherListCellViewModel {
    let titleText: String
    let sizeText: String
    let dateText: String
}
