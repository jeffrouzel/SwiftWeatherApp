//
//  HomeViewController.swift
//  SwiftWeatherApp
//
//  Created by training2 on 4/19/26.
//
import UIKit
import MapKit
import CoreLocation


class HomeViewController: UIViewController{
    
    // MARK: UI Components
    @IBOutlet weak var Lbl_city: UILabel!
    @IBOutlet weak var Lbl_country: UILabel!
    @IBOutlet weak var Lbl_temp: UILabel!
    @IBOutlet weak var Icon_weather: UIImageView!
    @IBOutlet weak var Lbl_condition: UILabel!
    @IBOutlet weak var Lbl_feelslike: UILabel!
    @IBOutlet weak var Lbl_humidity: UILabel!
    @IBOutlet weak var Lbl_sunrise: UILabel!
    @IBOutlet weak var Lbl_sunset: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: View Model and Maps
    var mapViewModel: MapViewModel = MapViewModel()
    var weatherViewModel: WeatherViewModel = WeatherViewModel()
    private let locationManager = CLLocationManager()	
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Current Weather"
        mapView.showsUserLocation = true
        locationManager.delegate = self
        bindViewModel()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    // This is needed for the navigationToolbar to appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    // MARK: Data Binding
    private func bindViewModel() {
        weatherViewModel.onWeatherUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.showContent()
            }
        }
        weatherViewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showError(message: message)
            }
        }
    }
    // MARK: Passing of values
    private func showContent() {
        Lbl_city.text = weatherViewModel.cityName
        Lbl_country.text = weatherViewModel.countryName
        Lbl_temp.text = weatherViewModel.temperatureText
        Lbl_feelslike.text = weatherViewModel.feelsLikeText
        Lbl_condition.text = weatherViewModel.conditionText
        Lbl_humidity.text = weatherViewModel.humidityText
        Lbl_sunrise.text = weatherViewModel.sunriseText
        Lbl_sunset.text = weatherViewModel.sunsetText

        Icon_weather.image = UIImage(systemName: weatherViewModel.weatherIconName)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.locationManager.startUpdatingLocation()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: Navigation
    @IBAction func toWeatherList(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toWeatherlist", sender: self)
    }
}

// MARK: MAPS
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()

        if let region = mapViewModel.region(for: locations) {
            mapView.setRegion(region, animated: true)
        }

        weatherViewModel.fetchWeather(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        )
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showError(message: "Could not find location: \(error.localizedDescription)")
    }
}
