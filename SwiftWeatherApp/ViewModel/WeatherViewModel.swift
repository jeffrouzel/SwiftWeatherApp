//
//  WeatherViewModel.swift
//  SwiftWeatherApplication
//
//  Created by training2 on 4/16/26.
//
import Foundation

class WeatherViewModel {
    var weather: WeatherResponse?
    var onWeatherUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let service: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }
    
    func fetchWeather(city: String) {
        Task {
            do {
                let weather = try await service.fetchWeather(city: city)
                self.weather = weather
                self.onWeatherUpdate?()
            } catch {
                self.onError?(error.localizedDescription)
            }
        }
    }
}
