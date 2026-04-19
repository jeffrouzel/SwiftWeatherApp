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
    
    // FETCH BY CITY (use in list)
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
    
    // FETCH BY LONGITUDE AND LATITUDE (use in home)
    func fetchWeather(lat: Double, lon: Double) {
        Task {
            do {
                let weather = try await service.fetchWeather(lat: lat, lon: lon)
                self.weather = weather
                self.onWeatherUpdate?()
            } catch {
                self.onError?(error.localizedDescription)
            }
        }
    }

    // MARK: Text Formatting for passing of data

    var cityName: String {
        weather?.name ?? ""
    }

    var countryName: String {
        weather?.sys.country ?? ""
    }

    var temperatureText: String {
        guard let temp = weather?.main.temp else { return "--" }
        return "\(Int(temp.rounded()))°C"
    }

    var feelsLikeText: String {
        guard let feelsLike = weather?.main.feelsLike else { return "--" }
        return "Feels like \(Int(feelsLike.rounded()))°C"
    }

    var conditionText: String {
        weather?.weather.first?.description.capitalized ?? "Unknown"
    }

    var humidityText: String {
        guard let humidity = weather?.main.humidity else { return "--" }
        return "Humidity: \(humidity)%"
    }

    var sunriseText: String {
        guard let weather else { return "--:--" }
        return formatTime(weather.sys.sunrise, timezone: weather.timezone)
    }

    var sunsetText: String {
        guard let weather else { return "--:--" }
        return formatTime(weather.sys.sunset, timezone: weather.timezone)
    }

    // MARK: Logic for WeatherIcons

    var isDay: Bool {
        guard let weather else { return true }
        let current = weather.dt + weather.timezone
        return current >= weather.sys.sunrise + weather.timezone &&
               current < weather.sys.sunset + weather.timezone
    }

    var weatherIconName: String {
        let condition = weather?.weather.first?.main ?? "Clear"
        switch condition.lowercased() {
        case "clear":
            return isDay ? "sun.max.fill" : "moon.stars.fill"
        case "clouds":
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case "rain", "drizzle":
            return "cloud.rain.fill"
        case "thunderstorm":
            return "cloud.bolt.rain.fill"
        case "snow":
            return "snowflake"
        case "mist", "fog", "haze":
            return "cloud.fog.fill"
        default:
            return "cloud.fill"
        }
    }

    // MARK: Private helpers
    private func formatTime(_ unix: Int, timezone: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
        return formatter.string(from: date)
    }
}
