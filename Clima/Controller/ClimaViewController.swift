//
//  ViewController.swift
//  Clima
//
//  Created by Shikhar Kumar on 1/15/20.
//  Copyright © 2020 Shikhar Kumar. All rights reserved.
//

import UIKit
import CoreLocation

class ClimaViewController: UIViewController {
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    let weatherStation = WeatherStation()
    let locationService = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarTextField.delegate = self
        weatherStation.delegate = self
        locationService.delegate = self
        
        locationService.requestWhenInUseAuthorization()
        locationService.requestLocation()
    }
}

// MARK: - UITextFieldDelegate

extension ClimaViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherStation.fetchWeather(for: searchBarTextField.text!)
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        weatherStation.fetchWeather(for: searchBarTextField.text!)
        searchBarTextField.endEditing(true)
    }
}

// MARK: - WeatherStationDelegate

extension ClimaViewController: WeatherStationDelegate {
    func didUpdateWeather(_ weatherStation: WeatherStation, _ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate

extension ClimaViewController: CLLocationManagerDelegate {
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationService.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print(location.coordinate.latitude, location.coordinate.longitude)
            manager.stopUpdatingLocation()
            weatherStation.fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
