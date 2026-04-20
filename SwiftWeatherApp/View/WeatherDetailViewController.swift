//
//  WeatherDetailViewController.swift
//  SwiftWeatherApp
//
//  Created by training2 on 4/20/26.
//
import UIKit

class WeatherDetailViewController: UIViewController {
    
    // MARK: UI Components
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var feelslike: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    
    // MARK: ViewModel
    var cityName_passed: String = ""
    var weatherViewModel: WeatherViewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ("\(cityName_passed) Weather Details")
        weatherViewModel.fetchWeather(city: cityName_passed)
        bindViewModel()
    }
    
    // MARK: Data Binding
    private func bindViewModel() {
        weatherViewModel.onWeatherUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.showContent()
            }
        }
        weatherViewModel.onError = { message in
            print("Error: \(message)")
        }
    }
    
    // MARK: Passing of values
    private func showContent() {
        cityName.text = weatherViewModel.cityName
        countryName.text = weatherViewModel.countryName
        temp.text = ("Temperature: \(weatherViewModel.temperatureText)")
        condition.text = ("Condition: \(weatherViewModel.conditionText)")
        feelslike.text = weatherViewModel.feelsLikeText
        humidity.text = weatherViewModel.humidityText
        sunrise.text = ("Sunrise Time: \(weatherViewModel.sunriseText)")
        sunset.text = ("Sunset Time: \(weatherViewModel.sunsetText)")
        
    }
}
