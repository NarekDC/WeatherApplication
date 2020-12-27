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
    var weeklyWeatherVM: WeeklyWeatherViewModel = WeeklyWeatherViewModel() {
        didSet {
            updateVM()
        }
    }
    
    private let cellID = "mCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateVM()
        setupTableView()
    }
    
    private func setupNavigationBar(){
        self.navigationItem.title = "Weather App"
    }
    
    private func setupTableView(){
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.register(WeeklyWeatherCell.self, forCellReuseIdentifier: "mCell")
    }
    
    fileprivate func fillUI() {
        if !isViewLoaded {
            return
        }
        
        // we are sure here that we have all the setup done
        
        self.cityNameLabel.text = weeklyWeatherVM.cityName
        self.currentStatusLabel.text = String(weeklyWeatherVM.currentInfo?.temp ?? 0)
    }
        
    private func updateVM() {

        weeklyWeatherVM.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.infoTableView.reloadData()
            }
        }
        weeklyWeatherVM.initFetch()
        weeklyWeatherVM.updateName = { name in
            self.cityNameLabel.text = name
        }
        
        weeklyWeatherVM.updateUI = { currentInfo in
            let sunsetDate = Date(timeIntervalSince1970: TimeInterval(currentInfo.sunset))
            let sunriseDate = Date(timeIntervalSince1970: TimeInterval(currentInfo.sunrise))
            
            self.cloudLabel.text = "Clouds: \(currentInfo.clouds) %"
            self.temperatureLabel.text = "\(currentInfo.temp) °"
            self.sunsetLabel.text = "Sunset: \(sunsetDate.amDate)"
            self.sunriseLabel.text = "Sunrise: \(sunriseDate.amDate)"
            self.windSpeedLabel.text = "Wind speed: \(currentInfo.windSpeed)"
            self.humidityLabel.text = "Humidity: \(currentInfo.humidity) %"
            self.pressureLabel.text = "Pressure: \(currentInfo.pressure) hPa"
        }
        
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
        return weeklyWeatherVM.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? WeeklyWeatherCell else {
            fatalError("Cell not in storyboard")
        }
        
        let cellVM = weeklyWeatherVM.getCellViewModel(at: indexPath)
        cell.weeklyWeatherListCellViewModel = cellVM
        cell.backgroundColor = UIColor(rgb: 0xFFFFFF)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


