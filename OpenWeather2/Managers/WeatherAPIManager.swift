//
//  WeatherAPIManager.swift
//  OpenWeather2
//
//  Created by htkien.dev@gmail.com on 11/07/2021.
//  Copyright © 2021 Hoang Trong Kien. All rights reserved.
//

import UIKit

class WeatherAPIManager {
    static let shared = WeatherAPIManager()
    
    /// https://openweathermap.org/forecast5
    /// Call 5 day / 3 hour forecast data
    func getFiveDayWeatherForecastData() {
        let url = "https://api.openweathermap.org/data/2.5/forecast?APPID=0e0877237e3aa921319e1e984c87f89d&q=Kabul"
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    guard let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                    
                    if let cityData = jsonData["city"] as? [String: Any] {
                        let city = CityModel(dict: cityData)
                        print(city.name)
                    }
                    
                } catch {
                    print(error)
                }
                
            } else if let error = error {
                print("DEBUG: \(error)")
            }
            
        }.resume()
    }
}
