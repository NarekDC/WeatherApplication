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
    var cityName: String? {
        didSet {
            self.updateName?(cityName ?? "")
        }
    }
    
    var reloadTableViewClosure: (()->())?
    var updateName: ((String) -> ())?
    var updateUI: ((Current) -> ())?

    var currentInfo: Current? {
        didSet {
            self.updateUI?(currentInfo ?? Current(sunrise: 0, sunset: 0, temp: 0, pressure: 0, humidity: 0, clouds: 0, windSpeed: 0))
        }
    }
    
    private var cellViewModels: [WeeklyWeatherListCellViewModel] = [WeeklyWeatherListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    
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
        self.cellViewModels = Array(self.weatherWeaklyInfoList.map { createCellViewModel(daily: $0) }.prefix(7))
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> WeeklyWeatherListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(daily:Daily) -> WeeklyWeatherListCellViewModel {
        let date = Date(timeIntervalSince1970: TimeInterval(daily.dt))
        let day = date.weekOnly

        return WeeklyWeatherListCellViewModel(titleText: day,
                                              sizeText: String(daily.temp.day),
                                              dateText: String(daily.temp.night) )
    }
}


struct WeeklyWeatherListCellViewModel {
    let titleText: String
    let sizeText: String
    let dateText: String
}
