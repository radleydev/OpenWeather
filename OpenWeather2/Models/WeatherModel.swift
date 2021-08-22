//
//  WeatherModel.swift
//  OpenWeather2
//
//  Created by htkien.dev@gmail.com on 06/07/2021.
//  Copyright © 2021 Hoang Trong Kien. All rights reserved.
//

import UIKit

class WeatherModel {
    var temp: CGFloat = 0
    var feelsLike: CGFloat = 0
    var tempMin: CGFloat = 0
    var tempMax: CGFloat = 0
    var pressure: Int = 0
    var seaLevel: Int = 0
    var grndLevel: Int = 0
    var humidity: Int = 0
    var tempKf: CGFloat = 0
    
    init() {}
    
    init(dict: [String: Any]) {
        self.temp = dict["temp"] as? CGFloat ?? 0
        self.feelsLike = dict["feels_like"] as? CGFloat ?? 0
        self.tempMin = dict["temp_min"] as? CGFloat ?? 0
        self.tempMax = dict["temp_max"] as? CGFloat ?? 0
        self.pressure = dict["pressure"] as? Int ?? 0
        self.seaLevel = dict["sea_level"] as? Int ?? 0
        self.grndLevel = dict["grnd_level"] as? Int ?? 0
        self.humidity = dict["humidity"] as? Int ?? 0
        self.tempKf = dict["temp_kf"] as? CGFloat ?? 0
    }
}
