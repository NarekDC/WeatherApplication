//
//  WeatherViewController.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/26/20.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentStatus: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var cloud: UILabel!
    @IBOutlet weak var windspeed: UILabel!
    @IBOutlet weak var infoTable: UITableView!

    var viewModel: CurrentWeatherViewModel? {
        didSet {
            DispatchQueue.main.async { self.updateView() }
        }
    }

    func updateView() {
        
        if let vm = viewModel, vm.isUpdateReady {
            updateWeatherContainer(with: vm)
        } else {
            
        }
    }

    func updateWeatherContainer(with vm: CurrentWeatherViewModel) {
        cityName.text = vm.city
        temperature.text = vm.temperature
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension WeatherViewController {
    class func instantiateFromStoryboard() -> WeatherViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        return vc
    }
}
