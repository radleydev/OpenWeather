//
//  WeatherCollectionViewCell.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import Charts

protocol ChangeButton: class {
    func isEveryDayTapped(_ isTapped: Bool)
}

class WeatherCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "Cell"
    
    // MARK: - Outlet
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var everyDaysButton: UIButton!
    @IBOutlet weak var everyHoursButton: UIButton!
    @IBOutlet weak var generalWeatherView: UIView!
    @IBOutlet weak var weekdaysLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    // Line Chart View
    @IBOutlet weak var lineChartView: LineChartView!
    weak var delegate: ChangeButton?
    // MARK: - Outlet Detail Weather
    @IBOutlet var iconDetailArray: [UIImageView]?
    @IBOutlet var dayDetailArray: [UILabel]?
    @IBOutlet var viewDetailArray: [UIView]?
    // MARK: - Action
    @IBAction func everyHourButtonTapped(_ sender: Any) {
        delegate?.isEveryDayTapped(false)
    }
    @IBAction func everyDayButtonTapped(_ sender: Any) {
        delegate?.isEveryDayTapped(true)
    }
}
