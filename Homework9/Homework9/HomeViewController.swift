//
//  FirstViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/23/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // init location manager status
    let locationManager = CLLocationManager()
    var locationManagerTrigger = 0
    
    // init pull to refresh
    var refreshControl = UIRefreshControl()
    
    // status to save current weather data
    var status = Status()
    
    // define weather standard
    enum MainWeather: String {
        case Clear = "clear"
        case Cloudy = "cloudy"
        case Rainy = "rainy"
        case Snowy = "snowy"
        case Sunny = "sunny"
        case Thunder = "thunder"
    }
    
    // api keys
    let openWeatherKey = "d32dc17259016e9927d18628475376ea"
    let guardianKey = "70e39bf2-86c6-4c5f-a252-ab34d91a4946"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // prepare tableview
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // enable pull down to refresh for table view
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /*
     Description:
     This function is used to describe how each cell should look like.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            // this should be the weather cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "Home Weather Cell") as! HomeWeatherTableViewCell

            // set up weather cell
            cell.labelCity.text = self.status.weather.city
            cell.labelState.text = self.status.weather.state
            cell.labelTemp.text = "\(self.status.weather.temp) °C"
            cell.labelWeather.text = self.status.weather.weather
            
            switch cell.labelWeather.text?.lowercased() {
            case MainWeather.Clear.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_clear"); break
            case MainWeather.Cloudy.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_cloudy"); break
            case MainWeather.Rainy.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_rainy"); break
            case MainWeather.Snowy.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_snowy"); break
            case MainWeather.Sunny.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_sunny"); break
            case MainWeather.Thunder.rawValue:
                cell.imageWeather.image = UIImage(named: "weather_thunder"); break
            default:
                cell.imageWeather.image = UIImage(named: "weather_sunny"); break
            }
            
            return cell
        } else {
            // this should be the news cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "Home News Cell") as! HomeNewsTableViewCell
            
            // set up news cell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            // this should be the weather cell
            return 110
        } else {
            // this should be the news cell
            return 150
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
                                let jsonObject = try JSONDecoder().decode(OpenWeather.self, from: data!)
                                
                                self.status.weather.temp = jsonObject.main.temp
                                self.status.weather.weather = jsonObject.weather[0].main
                                
                                // reload weather cell
                                DispatchQueue.main.async {
                                    let indexPath = IndexPath(row: 0, section: 0)
                                    self.tableView.reloadRows(at: [indexPath], with: .left)
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
    
    @objc func refresh(_ sender: AnyObject) {
        // refresh table view
        print("refresh")
        
        // prepare request
        let request = NSMutableURLRequest(url: URL(string: "https://content.guardianapis.com/search?orderby=newest&show-fields=starRating,headline,thumbnail,short-url&api-key=\(guardianKey)")!)
        
        // fetch data
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                // error
                return
            }
            
            if httpResponse.statusCode == 200 {
                // Http success
                do {
                    // save json as an object
                    let jsonObject = try JSONDecoder().decode(GuardianHome.self, from: data!)
                    
                    for result in jsonObject.response.results {
                        let image: String = result.fields.thumbnail ?? "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png"
                        let title: String = result.webTitle ?? "webTitle"
                        let time: String = result.webPublicationDate ?? "2020-04-26T03:02:14Z"
                        let section: String = result.sectionId ?? "sectionId"
                        let id: String = result.id ?? "id"
                        var news: News = News(image: image, title: title, time: time, section: section, id: id)
                        
//                        self.status["newsList"]?["news"].append()
                    }
                    
                    // reload weather cell
                    DispatchQueue.main.async {
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
        
        
        refreshControl.endRefreshing()
    }
}

