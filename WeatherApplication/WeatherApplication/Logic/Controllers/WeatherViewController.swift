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
    
    var viewModel: CurrentWeatherViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameLabel.text = "vm.location.name"
        temperatureLabel.text = "String(vm.weather.main.temp)"
    }

}

extension WeatherViewController {
    class func instantiateFromStoryboard() -> WeatherViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        return vc
    }
}
