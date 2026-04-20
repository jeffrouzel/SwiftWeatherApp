//
//  ViewController.swift
//  SwiftWeatherApplication
//
//  Created by training2 on 4/16/26.
//
import UIKit

class WeatherListViewController: UIViewController {

    // MARK: UI Components
    @IBOutlet weak var tableView_cities: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: ViewModel
    var viewModel: WeatherlistViewModel = WeatherlistViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather List"
        navigationItem.hidesBackButton = true
        tableView_cities.dataSource = self
        tableView_cities.delegate = self
        searchBar.delegate = self
        viewModel.loadCities()
        bindViewModel()
        
        
    }
    
    // MARK: Data Binding
    private func bindViewModel() {
        viewModel.onCitiesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView_cities.reloadData()
            }
        }

        viewModel.onError = { message in
            print("Error: \(message)")
        }
    }
    
    // MARK: Navigation
    @IBAction func gotoCurrentWeather(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: TableView DataSource
extension WeatherListViewController: UITableViewDataSource {
    // Tells how many rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCities()
    }

    // The data ui
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = viewModel.city(at: indexPath.row)
        return cell
    }
}

// MARK: Used to supply behaviour of table
extension WeatherListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "WeatherDetailViewController") as! WeatherDetailViewController
        detailVC.cityName_passed = viewModel.city(at: indexPath.row)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: Used to supply behaviour of searchbar
extension WeatherListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text, !city.isEmpty else { return }
        viewModel.addCity(city)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
