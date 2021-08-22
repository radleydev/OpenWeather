//
//  CityModel.swift
//  OpenWeather2
//
//  Created by htkien.dev@gmail.com on 11/07/2021.
//  Copyright © 2021 Hoang Trong Kien. All rights reserved.
//

import UIKit

class CityModel {
    var id: Int = 0
    var name: String = ""
    var coord: CoordModel = CoordModel()
    var country: String = ""
    var population: Int = 0
    var timezone: Int = 0
    var sunrise: Int = 0
    var sunset: Int = 0
    
    init() {}
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
        if let dataDict = dict["coord"] as? [String: Any] {
            self.coord = CoordModel(dict: dataDict)
        }
        self.country = dict["country"] as? String ?? ""
        self.population = dict["population"] as? Int ?? 0
        self.timezone = dict["timezone"] as? Int ?? 0
        self.sunrise = dict["sunrise"] as? Int ?? 0
        self.sunset = dict["sunset"] as? Int ?? 0
    }
}

class CoordModel {
    var lat: CGFloat = 0
    var long: CGFloat = 0
    
    init() {}
    
    init(dict: [String: Any]) {
        self.lat = dict["lat"] as? CGFloat ?? 0
        self.long = dict["long"] as? CGFloat ?? 0
    }
}
