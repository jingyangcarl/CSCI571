//
//  HomeTableViewController.swift
//  Homework9
//
//  Created by Jing Yang on 5/6/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import SwiftSpinner

class HomeTableViewController: NavigationTableViewController, CLLocationManagerDelegate, ClickOnSubviewDelegate, UISearchBarDelegate, UIAdaptivePresentationControllerDelegate {
    
    // init location manager status
    let locationManager = CLLocationManager()
    var locationManagerTrigger = 0
    
    // define weather standard
    enum HomeWeather: String {
        case Clear = "clear"
        case Cloudy = "cloudy"
        case Rainy = "rainy"
        case Snowy = "snowy"
        case Sunny = "sunny"
        case Thunder = "thunder"
    }
    
//    enum HomeSession: Int {
//        case Weather = 0
//        case News = 1
//    }
    
    // api keys
    let openWeatherKey = "d32dc17259016e9927d18628475376ea"
    let bingKey = "79f5b5a589c74be4aa1d102ca11fadd2"
    
    var autoSuggestTableViewController: AutoSuggestTableViewController!
    var isFirstSearchLetter: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // redefine session identifier
        sessionIdentifier = [
            "weather": 0,
            "news": 1
        ]
        
        // prepare searchbar
        self.navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController?.searchBar.showsCancelButton = true
        self.navigationItem.searchController?.searchBar.delegate = self
        self.navigationItem.searchController?.searchBar.placeholder = "Enter keyword ..."
        
        // initialize
        self.autoSuggestTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "search")
        self.autoSuggestTableViewController.clickOnSubviewDelegate = self
        
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        if indexPath.section == self.sessionIdentifier["weather"] {
            // this should be the weather cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "Weather Cell") as! WeatherTableViewCell
            
            // set up weather cell
            cell.labelCity.text = self.status.weather.city
            cell.labelState.text = self.status.weather.state
            cell.labelTemp.text = "\(self.status.weather.temp) °C"
            cell.labelWeather.text = self.status.weather.weather
            
            switch cell.labelWeather.text?.lowercased() {
            case HomeWeather.Clear.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_clear"); break
            case HomeWeather.Cloudy.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_cloudy"); break
            case HomeWeather.Rainy.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_rainy"); break
            case HomeWeather.Snowy.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_snowy"); break
            case HomeWeather.Sunny.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_sunny"); break
            case HomeWeather.Thunder.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_thunder"); break
            default:
                cell.imageWeather.image = UIImage(named: "weather_sunny"); break
            }
            
            return cell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case self.sessionIdentifier["weather"]:
            return 110
        case self.sessionIdentifier["news"]:
            return 140
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case self.sessionIdentifier["weather"]:
            return 1
        case self.sessionIdentifier["news"]:
            return self.status.newsDict.count
        default:
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /*
     Description:
     This function is triggered everytime location is updated. Basically this function is called every second.
     Everytime location is updated, weather should be updated as well.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // trigger to fetch weather data
        locationManagerTrigger = (locationManagerTrigger + 1) % 10
        if locationManagerTrigger != 1 {return}
        
        if let location = locations.first {
            
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                if error == nil {
                    // get current location
                    let readableLocation = placemarks?[0]
                    self.status.weather.city = (readableLocation?.locality)!
                    self.status.weather.state = (readableLocation?.administrativeArea)!
                    
                    // prepare request
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                    let request = NSMutableURLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longitude.description)&units=metric&appid=\(self.openWeatherKey)")!)
                    
                    // fetch data from openweathermap
                    URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                        guard let httpResponse = response as? HTTPURLResponse else {
                            // rrror
                            return
                        }
                        
                        if httpResponse.statusCode == 200 {
                            // Http success
                            do {
                                // save json as an object
                                let jsonObject_ = try JSON(data: data!)
                                
                                self.status.weather.temp = jsonObject_["main"]["temp"].double!
                                self.status.weather.weather = jsonObject_["weather"][0]["main"].stringValue
                                
                                // reload weather cell
                                DispatchQueue.main.async {
                                    let indexPath = IndexPath(row: 0, section: self.sessionIdentifier["weather"]!)
                                    self.tableView.reloadRows(at: [indexPath], with: .right)
                                    
                                }
                                
                            } catch DecodingError.dataCorrupted(let context) {
                                print(context.debugDescription)
                            } catch DecodingError.keyNotFound(let key, let context) {
                                print("\(key.stringValue) was not found, \(context.debugDescription)")
                            } catch DecodingError.typeMismatch(let type, let context) {
                                print("\(type) was expected, \(context.debugDescription)")
                            } catch DecodingError.valueNotFound(let type, let context) {
                                print("no value was found for \(type), \(context.debugDescription)")
                            } catch let error {
                                print(error)
                            }
                        } else {
                            // Http error
                        }
                    }.resume()
                }
            })
        }
    }
    
    /*
     This function is used to perform refreshing from Guardian news
     */
    @objc override func handleRefresh(_ sender: AnyObject) {
        
        // prepare request
        let request = NSMutableURLRequest(url: URL(string: "https://content.guardianapis.com/search?orderby=newest&show-fields=starRating,headline,thumbnail,short-url&api-key=\(guardianKey)")!)
        
        return super.handleRefresh(request)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == SegueIdentifier.SearchResult.rawValue {
            guard let searchResultTableViewController = segue.destination as? SearchResultTableViewController else { return }
            guard let keyword = sender as? String else { return }
            searchResultTableViewController.keyword = keyword
        }
    }
    
    func didCellClickedOnSubview(cellForRowAt indexPath: IndexPath) {
        guard let cell = self.autoSuggestTableViewController.tableView.cellForRow(at: indexPath) else { return }
        performSegue(withIdentifier: "SearchResultSegue", sender: cell.textLabel?.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if self.isFirstSearchLetter {
            self.navigationItem.searchController?.present(self.autoSuggestTableViewController, animated: true, completion: nil)
            searchBar.becomeFirstResponder()
            self.isFirstSearchLetter = false
        }
        
        let request = NSMutableURLRequest(url: URL(string: "https://api.cognitive.microsoft.com/bing/v7.0/suggestions?q=\(searchText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.setValue(bingKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        // fetch data
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 200 {
                // Http success
                do {
                    // save json as an object
                    let jsonObject = try JSON(data: data!)
                    
                    self.autoSuggestTableViewController.suggestions.removeAll()
                    
                    for (_, suggestion): (String, JSON) in jsonObject["suggestionGroups"][0]["searchSuggestions"] {
                        self.autoSuggestTableViewController.suggestions.append(suggestion["query"].stringValue)
                    }
                    
                    DispatchQueue.main.async {
                        self.autoSuggestTableViewController.tableView.reloadData()
                    }
                    
                    
                } catch DecodingError.dataCorrupted(let context) {
                    print(context.debugDescription)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("\(key.stringValue) was not found, \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("\(type) was expected, \(context.debugDescription)")
                } catch DecodingError.valueNotFound(let type, let context) {
                    print("no value was found for \(type), \(context.debugDescription)")
                } catch let error {
                    print(error)
                }
            } else {
                // Http error
            }
            
        }.resume()
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isFirstSearchLetter = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

protocol ClickOnSubviewDelegate {
    func didCellClickedOnSubview(cellForRowAt indexPath: IndexPath)
}
