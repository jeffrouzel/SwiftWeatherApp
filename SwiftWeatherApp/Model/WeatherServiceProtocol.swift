//
//  WeatherServiceProtocol.swift
//  SwiftWeatherApplication
//
//  Created by training2 on 4/16/26.
//
import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(city: String) async throws -> WeatherResponse
}

class WeatherService: WeatherServiceProtocol {
    private var apiKey: String {
            guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
                fatalError("API_KEY not found in Info.plist")
            }
            return key
        }
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(city: String) async throws -> WeatherResponse {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
