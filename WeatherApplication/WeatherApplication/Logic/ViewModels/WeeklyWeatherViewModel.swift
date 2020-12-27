//
//  WeeklyWeatherViewModel.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/27/20.
//


import Foundation

final class WeeklyWeatherViewModel {
    
    private var dataRepo: DataRepositoryProtocol
    var weatherWeaklyInfoList = [Daily]()
    var cityName: String = String()
    var currentInfo: Current?
    
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
        dataRepo.getDBDataInfo{ [weak self] result in
            switch result{
            case .success(let weatherInfo):
                self?.processWeatherInfoToCellModel(weatherInfo: weatherInfo)
            case .failure(let error):
                self?.processError(error: error)
            }
        }
    }
    
    private func processError(error:DataManagerError) {
        Global.printToConsole(message: error.localizedDescription)
    }
    
    private func processWeatherInfoToCellModel(weatherInfo: WeatherInfo) {
        
        self.cityName = weatherInfo.timezone
        self.weatherWeaklyInfoList = weatherInfo.daily
        self.currentInfo = weatherInfo.current
        self.cellViewModels = self.weatherWeaklyInfoList.map { createCellViewModel(daily: $0) }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> WeeklyWeatherListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(daily:Daily) -> WeeklyWeatherListCellViewModel {
        let meteoriteMass = "UNKNOWN"
        let meteoriteDate = "UNKNOWN"
        let temp = "\(daily.temp)"
        
        return WeeklyWeatherListCellViewModel(titleText: temp,
                                            sizeText: meteoriteMass,
                                            dateText: meteoriteDate )
    }
}


struct WeeklyWeatherListCellViewModel {
    let titleText: String
    let sizeText: String
    let dateText: String
}
