//
//  WeatherViewController.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/26/20.
//

import UIKit

class WeatherViewController: UIViewController { 
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var infoTableView: UITableView!
    
    var currentWeatherViewModel: CurrentWeatherViewModel?
    
    private lazy var meteoriteVM: MeteoriteViewModel = {
        return MeteoriteViewModel()
    }()
    
    private let cellID = "mCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        initVM()
    }
    
    private func setupNavigationBar(){
        self.navigationItem.title = "Weather App"
    }
    
    private func setupTableView(){
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.register(MeteoriteListCell.self, forCellReuseIdentifier: "mCell")
    }
    
    private func initVM() {
        
        meteoriteVM.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.meteoriteVM.isLoading ?? false
                if isLoading {
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.infoTableView.alpha = 0.0
                    })
                }else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.infoTableView.alpha = 1.0
                    })
                }
            }
        }
        
        meteoriteVM.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.infoTableView.reloadData()
            }
        }
        meteoriteVM.initFetch()
    }

}

extension WeatherViewController {
    class func instantiateFromStoryboard() -> WeatherViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        return vc
    }
}

extension WeatherViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meteoriteVM.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MeteoriteListCell else {
            fatalError("Cell not in storyboard")
        }
        
        let cellVM = meteoriteVM.getCellViewModel(at: indexPath)
        cell.meteoriteListCellViewModel = cellVM
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if meteoriteVM.isSegueAllowed {
            return indexPath
        }else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


