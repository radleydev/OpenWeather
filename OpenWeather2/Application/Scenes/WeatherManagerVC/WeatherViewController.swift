//
//  WeatherViewController.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/15/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import Charts
import MapKit

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var underImageView: UIImageView!
    @IBOutlet weak var updatedDayLabel: UILabel!
    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    
    private var items: [DataStructs] = []
    private var isEveryDaysChecked = false
    private var existCity: [Int] = [1583992] // id of default city (Da Nang)
    private var locationManager: CLLocationManager!
    
    // MARK: - Helper
    func setUpHeaderButton() {
        addButton.corner()
        addButton.border()
        addButton.shadow()
        cityButton.corner()
        cityButton.border()
        cityButton.shadow()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changePageControl()
        //changeUnderImage()
    }
    
    func setUpCollectionView() {
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func setUpPageControl() {
        pageControl.numberOfPages = items.count < 1 ? 1 : items.count
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.white
    }
    
    func changePageControl() {
        pageControl.currentPage = getCurrentIndex()
    }
    
    private func getCurrentIndex() -> Int {
        return Int(collectionView.contentOffset.x / collectionView.frame.width)
    }
    
    func setUpWeather(_ cell: WeatherCollectionViewCell,
                      indexPath: IndexPath) {
        // set up for labels
        cell.generalWeatherView.border()
        cell.cityLabel.shadow()
        cell.temperatureLabel.shadow()
        cell.weatherDescriptionLabel.shadow()
        cell.humidityLabel.shadow()
        cell.dateLabel.shadow()
        cell.weekdaysLabel.shadow()
        for index in 0..<6 {
            cell.viewDetailArray![index].border()
        }
        // set information for general weather
        let currentIndex = HelperWeather.getLastedIndex(data: items[indexPath.item]) + 1
        cell.cityLabel.text = String("\(self.items[indexPath.item].city.name)")
        cell.temperatureLabel.text = String("\(Int(self.items[indexPath.item].list[currentIndex].main.temp - 273))°")
        cell.weatherDescriptionLabel.text = String(
            "\(self.items[indexPath.item].list[currentIndex].weather[0].weatherDescription)"
        )
        cell.humidityLabel.text = String("\(self.items[indexPath.item].list[currentIndex].main.humidity) %")
        cell.iconImageView.image = UIImage(named: self.items[indexPath.item].list[currentIndex].weather[0].icon)
        // set date time
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
        // set weekdays
        let weekdays = GetWeekDays.getWeekdays()
        cell.weekdaysLabel.text = dateFormatter.weekdaySymbols[weekdays]
    }
    
    func setUpEveryHours(_ cell: WeatherCollectionViewCell,
                         indexPath: IndexPath) {
        // highligh button if button is checking
        cell.everyHoursButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.6039215686, blue: 0.7803921569, alpha: 0.55)
        cell.everyDaysButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.6941176471, blue: 0.8941176471, alpha: 0.55)
        // set up detail weather every hour
        let detailEveryHour = HelperWeather.getWeatherEveryHour(data: items[indexPath.item])
        let lastedIndex = HelperWeather.getLastedIndex(data: items[indexPath.item])
        for index in 0..<6 {
            cell.dayDetailArray![index].text = detailEveryHour[index+lastedIndex]
            cell.iconDetailArray![index].image = UIImage(named:
                                                            self.items[indexPath.item].list[index+lastedIndex].weather[0].icon)
        }
    }
    
    func setUpEveryDays(_ cell: WeatherCollectionViewCell,
                        indexPath: IndexPath) {
        cell.everyDaysButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.6039215686, blue: 0.7803921569, alpha: 0.55)
        cell.everyHoursButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.6941176471, blue: 0.8941176471, alpha: 0.55)
        let currentIndex = HelperWeather.getLastedIndex(data: items[indexPath.item]) + 1
        for index in 0..<6 {
            // [list] in JSON has 40 element
            let subIndex = index*8 + currentIndex > 39 ? 39 : index*8 + currentIndex
            let dayOfWeek = GetWeekDays.get6FollowingDays()
            cell.dayDetailArray![index].text = dayOfWeek[index]
            cell.iconDetailArray![index].image = UIImage(named:
                                                            self.items[indexPath.item].list[subIndex].weather[0].icon)
        }
    }
    
    func setUpdatedTime() {
        let currentDate = Date()
        // get time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        updatedTimeLabel.text = dateFormatter.string(from: currentDate)
        // get date
        dateFormatter.dateFormat = "dd-MM-yyyy"
        updatedDayLabel.text = dateFormatter.string(from: currentDate)
    }
    
    func setUpLineChartViewForEveryDays(_ cell: WeatherCollectionViewCell, indexPath: IndexPath) {
        var values: [Double] = []
        let lastedIndex = HelperWeather.getLastedIndex(data: items[indexPath.item])
        for index in 0..<6 {
            // change temperature to Integer. Ex: 26.5 => 27
            let temp = Int(self.items[indexPath.item].list[index+lastedIndex].main.temp - 273)
            values.append(Double(temp))
        }
        cell.lineChartView.data = CustomLineChartView.dataChart(values: values)
        CustomLineChartView.settingChart(lineChartView: cell.lineChartView)
    }
    
    func setUpLineChartViewForEveryWeeks(_ cell: WeatherCollectionViewCell, indexPath: IndexPath) {
        var values: [Double] = []
        let currentIndex = HelperWeather.getLastedIndex(data: items[indexPath.item]) + 1
        for index in 0..<6 {
            // [list] in JSON has 40 element
            let subIndex = index*8 + currentIndex > 39 ? 39 : index*8 + currentIndex
            let temp = Int(self.items[indexPath.item].list[subIndex].main.temp - 273)
            values.append(Double(temp))
        }
        cell.lineChartView.data = CustomLineChartView.dataChart(values: values)
        CustomLineChartView.settingChart(lineChartView: cell.lineChartView)
    }
    
    func setUpHourNDayButton(_ cell: WeatherCollectionViewCell) {
        cell.everyHoursButton.corner()
        cell.everyHoursButton.shadow()
        cell.everyHoursButton.border()
        cell.everyDaysButton.corner()
        cell.everyDaysButton.shadow()
        cell.everyDaysButton.border()
    }
}

// MARK: - Life cycle
extension WeatherViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()

        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        setUpHeaderButton()
        setUpPageControl()
        setUpCollectionView()
           
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue = locations.last! as CLLocation
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        // commit
        // tesst 1231231
        // branch 1
        // resolve conflict
        print("locations = \(locValue.coordinate.latitude) \(locValue.coordinate.longitude)")
    }
}

// MARK: - Action
extension WeatherViewController {
    @IBAction func refreshButtonTapped(_ sender: Any) {
        let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
        let currentIndex = pageControl.currentPage
        let city = items[currentIndex].city.name
        dataManager.weatherDataForLocation(city: city) { (data, error) in
            if let error = error {
                print(error)
            } else {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.items[currentIndex] = data
                    self.collectionView.reloadData()
                    self.setUpdatedTime()
                    // reload animation
                    let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                    rotateAnimation.fromValue = 0.0
                    rotateAnimation.toValue = CGFloat(.pi * 2.0)
                    rotateAnimation.duration = 1
                    
                    self.refreshButton.layer.add(rotateAnimation, forKey: nil)
                }
            }
        }
    }
}

// MARK: - API
extension WeatherViewController {
    func loadDataFromAPI(_ cell: WeatherCollectionViewCell,
                         indexPath: IndexPath,
                         city: String) {
        let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
        dataManager.weatherDataForLocation(city: city) { (data, error) in
            if error != nil {
                print(error!)
            } else {
                DispatchQueue.main.async {
                    self.items.append(data!)
                    self.setUpWeather(cell, indexPath: indexPath)
                    self.setUpdatedTime()
                    self.setUpEveryHours(cell, indexPath: indexPath)
                    self.setUpLineChartViewForEveryDays(cell, indexPath: indexPath)
                    //self.changeUnderImage()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        // API khong kip tra ve nen items.count = 0 => failed
        return items.count < 1 ? 1 : items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.reuseIdentifier, for: indexPath) as! WeatherCollectionViewCell
        if items.isEmpty {
            loadDataFromAPI(cell, indexPath: indexPath, city: "DaNang")
            self.setUpHourNDayButton(cell)
        } else {
            //self.changeUnderImage()
            self.setUpWeather(cell, indexPath: indexPath)
            if self.isEveryDaysChecked {
                self.setUpEveryDays(cell, indexPath: indexPath)
                self.setUpLineChartViewForEveryWeeks(cell, indexPath: indexPath)
            } else {
                self.setUpEveryHours(cell, indexPath: indexPath)
                self.setUpLineChartViewForEveryDays(cell, indexPath: indexPath)
            }
            self.setUpdatedTime()
            self.setUpHourNDayButton(cell)
        }
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Prepare Segue
extension WeatherViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AllCitiesViewController {
            let vc = segue.destination as! AllCitiesViewController
            vc.items = items
            vc.selectedCityDelegate = self
            vc.deletedCityDelegate = self
        } else if segue.destination is AddCityViewController {
            let vc = segue.destination as! AddCityViewController
            vc.addCityDelegate = self
        }
    }
}

// MARK: - Protocol Delegate
// WeatherCollectionViewCell
extension WeatherViewController: ChangeButton {
    func isEveryDayTapped(_ isTapped: Bool) {
        isEveryDaysChecked = isTapped
        collectionView.reloadData()
    }
}

// AllCitiesTableViewController
extension WeatherViewController: SelectedCity, DeletedCity {
    func deletedCity(items: [DataStructs], deletedCityID: Int) {
        self.items = items
        self.existCity.remove(at: existCity.firstIndex(of: deletedCityID)!)
        collectionView.reloadData()
        setUpPageControl()
    }
    func selectedCity(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// AddCityViewController
extension WeatherViewController: AddCity {
    func addCity(name: String) {
        // remove space in name
        var safeName = name
        while safeName.contains(" ") {
            safeName.removeAll { (char) -> Bool in
                char == " "
            }
        }
        let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
        dataManager.weatherDataForLocation(city: safeName) { (data, error) in
            if error != nil {
                DispatchQueue.main.async {
                    print(error!)
                }
            } else {
                DispatchQueue.main.async {
                    // check if it had that city, go to that one
                    if self.isExistCity(idCity: data!.city.id) {
                        return
                    }
                    self.items.append(data!)
                    self.collectionView.reloadData()
                    // go to new item
                    let indexPath = IndexPath(item: self.items.count-1, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    self.setUpPageControl()
                    // when add a city, dismiss current viewcontroller and display new city in main screen
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    private func isExistCity(idCity: Int) -> Bool {
        if existCity.contains(idCity) {
            let index = existCity.firstIndex(of: idCity)!
            let indexPath = IndexPath(item: Int(index), section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            return true
        } else {
            existCity.append(idCity)
            return false
        }
    }
}
