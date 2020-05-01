//
//  WeatherStation.swift
//  Clima
//
//  Created by Shikhar Kumar on 1/16/20.
//  Copyright © 2020 Shikhar Kumar. All rights reserved.
//

import Foundation

class WeatherStation {
    var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=c38dd77a6ab86721792bef9917f498b0&units=metric"
    var delegate: WeatherStationDelegate?
    
    func fetchWeather(lat latitude: Double, lon longitude: Double) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performSearch(urlString)
    }
    
    func fetchWeather(for city: String) {
        let citySpaceSkipped = city.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let urlString = "\(weatherUrl)&q=\(citySpaceSkipped)"
        performSearch(urlString)
    }
    
    func performSearch(_ urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decoded = try decoder.decode(WeatherData.self, from: data)
            return WeatherModel(cityName: decoded.name, weatherId: decoded.weather[0].id, temperature: decoded.main.temp)
        } catch {
            delegate?.didFailWithError(error)
        }
        return nil
    }
    
    
}

protocol WeatherStationDelegate {
    func didUpdateWeather(_ weatherStation: WeatherStation, _ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}
