//
//  WeatherlistViewModel.swift
//  SwiftWeatherApp
//
//  Created by training2 on 4/19/26.
//
import Foundation

class WeatherlistViewModel {

    var cities: [String] = []
    var onCitiesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    private let defaultCities = ["Manila", "Tokyo", "London", "New York", "Paris"]
    private let storageKey = "saved_cities"

    func loadCities() {
        let saved = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        cities = defaultCities + saved.filter { city in !defaultCities.contains(city) }
        onCitiesUpdated?()
    }

    func addCity(_ city: String) {
        let trimmed = city.trimmingCharacters(in: .whitespaces) // remove any whitespace
        guard !trimmed.isEmpty, !cities.contains(trimmed) else { return }   // do not add duplicates
        cities.append(trimmed)
        saveUserCities()
        onCitiesUpdated?()
    }
    
    func numberOfCities() -> Int { cities.count } // number of rows

    func city(at index: Int) -> String { cities[index] } // For selecting the data

    private func saveUserCities() {
        let userCities = cities.filter { city in !defaultCities.contains(city) }
        UserDefaults.standard.set(userCities, forKey: storageKey)
    }
}
