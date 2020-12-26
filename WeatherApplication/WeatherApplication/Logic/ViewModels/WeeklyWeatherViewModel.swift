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

final class MeteoriteViewModel {
    private var dataRepo: DataRepositoryProtocol
    var meteoriteList = [Meteorite]()
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
        
        dataRepo.initFetch{ [weak self] result in
            self?.isLoading = false
            
            switch result{
            case .success(let meteorites):
                self?.processMeteoriteToCellModel(meteorites: meteorites)
            case .failure(let error):
                self?.processError(error: error)
            }
        }
    }
    
    private func processError(error:APIError) {
        switch error {
        case .clientError:
            self.alertMessage = UserAlert.userError.rawValue
            
        case .serverError,.noData,.dataDecodingError:
            self.alertMessage = UserAlert.serverError.rawValue
        }
    }
    
    private func processMeteoriteToCellModel(meteorites: [Meteorite]) {
        
        self.meteoriteList = meteorites.sorted(by: { $0.mName > $1.mName })
        self.cellViewModels = self.meteoriteList.map { createCellViewModel(meteorite: $0) }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> MeteoriteListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(meteorite:Meteorite) -> MeteoriteListCellViewModel {
        let meteoriteMass = "UNKNOWN"
        let meteoriteDate = "UNKNOWN"
        
        return MeteoriteListCellViewModel(  titleText: meteorite.mName,
                                            sizeText: meteoriteMass,
                                            dateText: meteoriteDate )
    }
}


struct MeteoriteListCellViewModel {
    let titleText: String
    let sizeText: String
    let dateText: String
}
