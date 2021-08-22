//
//  AppDataSingleton.swift
//  OpenWeather2
//
//  Created by htkien.dev@gmail.com on 15/07/2021.
//  Copyright © 2021 Hoang Trong Kien. All rights reserved.
//

import UIKit
import MapKit

class AppDataSingleton {
    static var shared = AppDataSingleton()
    
    var currentLocation: CLLocation!
}
