//
//  ViewController.swift
//  SwiftWeatherApplication
//
//  Created by training2 on 4/16/26.
//

import UIKit

class ViewController: UIViewController {
    
    var weatherViewModel: WeatherViewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.fetchWeather(city: "Manila")

        weatherViewModel.onWeatherUpdate = { [weak self] in
            guard let self = self else { return }
            
            if let weather = self.weatherViewModel.weather {
                print("City:", weather.name)
                print("Temperature:", weather.main.temp)
            }
        }

        weatherViewModel.onError = { error in
            print("Error:", error)
        }
    }
}
