//
//  WeatherModel.swift
//  Clima
//
//  Created by Shikhar Kumar on 1/16/20.
//  Copyright © 2020 Shikhar Kumar. All rights reserved.
//

import Foundation

struct WeatherModel {
    var cityName: String
    var weatherId: Int
    var temperature: Double
    
    var conditionName: String {
        switch weatherId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.min"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    var temperatureString :String {
        return String(format: "%.1f", temperature)
    }
}
