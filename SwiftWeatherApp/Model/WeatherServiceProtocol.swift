//
//  WeatherServiceProtocol.swift
//  SwiftWeatherApplication
//
//  Created by training2 on 4/16/26.
//
import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(city: String) async throws -> WeatherResponse
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse
}

class WeatherService: WeatherServiceProtocol {
    private var apiKey: String {
            guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
                fatalError("API_KEY not found in Info.plist")
            }
            return key
        }
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    // MARK: Fetch weather by city (for city inputs, used for the weather lists)
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
    
    // MARK: Fetch weather by latitude and longitude (good for when using CLLocationManager for current location by IOS)
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
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
