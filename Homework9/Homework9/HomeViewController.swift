//
//  FirstViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/23/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, NewsBookmarkDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // init location manager status
    let locationManager = CLLocationManager()
    var locationManagerTrigger = 0
    
    // init pull to refresh
    let refreshControl = UIRefreshControl()
    
    // status to save current data
    var status = Status()
    
    // define weather standard
    enum HomeWeather: String {
        case Clear = "clear"
        case Cloudy = "cloudy"
        case Rainy = "rainy"
        case Snowy = "snowy"
        case Sunny = "sunny"
        case Thunder = "thunder"
    }
    
    enum HomeSession: Int {
        case Weather = 0
        case News = 1
    }
    
    // api keys
    let openWeatherKey = "d32dc17259016e9927d18628475376ea"
    let guardianKey = "70e39bf2-86c6-4c5f-a252-ab34d91a4946"
    
    var newsBookmarkDetailDelegate: NewsBookmarkDetailDelegate!
    
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
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        // init bookmark delegte, since Bookmark View Controler will not load early than Home View Controller, initialization should be done here
        guard let bookmarkViewController = self.parent?.parent?.children[3].children[0] as? BookmarkViewController else { return }
        self.newsBookmarkDetailDelegate = bookmarkViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // refersh tableview
        handleRefresh(self)
    }
    
    // MARK: - Table view data source
    
    /*
     Description:
     This function is used to describe how each cell should look like.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == HomeSession.Weather.rawValue {
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
        } else if indexPath.section == HomeSession.News.rawValue {
            // this should be the news cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "News Cell") as! NewsTableViewCell
            
            // set up news cell
            if !self.status.newsDict.isEmpty {
                
                var news = Array(self.status.newsDict.values)[indexPath.row]
                
                if self.newsBookmarkDetailDelegate != nil {
                    // check if the news is already in the bookmark list
                    if self.newsBookmarkDetailDelegate.existBookmark(id: news.id) {
                        news.bookmark = true
                    } else {
                        news.bookmark = false
                    }
                }
                
                cell.setNews(news: news, indexPath: indexPath)
            }
            
            cell.newsBookmarkDelegate = self
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {suggestedActions in
            
            let twitterMenu = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter")) { action in
                // share
                
                let tweetText = "Check out this Article!"
                let tweetUrl = Array(self.status.newsDict.values)[indexPath.row].url
                let tweetHashtag = "CSCI_571_NewsApp"
                
                let shareUrl = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)&hashtags=\(tweetHashtag)"
                
                guard let url = URL(string: shareUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else { return }
                
                UIApplication.shared.open(url)
            }
            let bookMarkMenu = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                //
            }
            
            // Create and return a UIMenu with the share action
            return UIMenu(title: "Main Menu", children: [twitterMenu, bookMarkMenu])
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.status.selectedIndexPath = indexPath
        performSegue(withIdentifier: "NewsDetailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == HomeSession.Weather.rawValue {
            // this should be the weather cell
            return 110
        } else if indexPath.section == HomeSession.News.rawValue {
            // this should be the news cell
            return 140
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == HomeSession.Weather.rawValue {
            return 1
        } else if section == HomeSession.News.rawValue {
            return self.status.newsDict.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
                                    let indexPath = IndexPath(row: 0, section: HomeSession.Weather.rawValue)
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
    @objc func handleRefresh(_ sender: AnyObject) {
        
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
                    let jsonObject = try JSON(data: data!)
                    
                    for (_, result): (String, JSON) in jsonObject["response"]["results"] {
                        let imageUrl: String = result["fields"]["thumbnail"].stringValue
                        let title: String = result["webTitle"].stringValue
                        let date: String = result["webPublicationDate"].stringValue
                        let section: String = result["sectionId"].stringValue
                        let id: String = result["id"].stringValue
                        let url: String = result["webUrl"].stringValue
                        
                        if self.status.newsDict[id] == nil {
                            let news: News = News(imageUrl: imageUrl, title: title, date: date, section: section, id: id, url: url)
                            self.status.newsDict[id] = news
                        }
                    }
                    
                    // reload news cell
                    DispatchQueue.main.async {
                        self.tableView.reloadSections(IndexSet(arrayLiteral: HomeSession.News.rawValue), with: .automatic)
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
    
    // MARK: - Table view segue
    
    /*
     This function is used to prepare data and segue to Detialed View
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NewsDetailSegue" {

            guard let newsDetailViewController = segue.destination as? NewsDetailViewController else { return }
            
            // prepare data will be used in Detail View
            newsDetailViewController.status.key.id = Array(self.status.newsDict.values)[self.status.selectedIndexPath.row].id
            newsDetailViewController.status.key.bookmark = Array(self.status.newsDict.values)[self.status.selectedIndexPath.row].bookmark
            newsDetailViewController.status.key.apiKey = guardianKey
            newsDetailViewController.status.key.indexPath = self.status.selectedIndexPath
            newsDetailViewController.newsBookmarkDelegate = self
        } else {
            
        }
    }
    
    func didBookmarkClickedFromSubView(_ bookmark: Bool, cellForRowAt indexPath: IndexPath) {
        
        guard let cell = self.tableView.cellForRow(at: indexPath) as? NewsTableViewCell else { return }
        self.status.newsDict[cell.id]?.bookmark = bookmark
        
        if self.newsBookmarkDetailDelegate != nil {
            if bookmark {
                self.newsBookmarkDetailDelegate.addBookmark(id: cell.id, news: self.status.newsDict[cell.id]!)
            } else {
                self.newsBookmarkDetailDelegate.removeBookmark(id: cell.id)
            }
        }
        
        DispatchQueue.main.async {
            if bookmark {
                cell.buttonBookmark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                cell.buttonBookmark.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
        
    }
}

protocol NewsBookmarkDelegate {
    func didBookmarkClickedFromSubView(_ bookmark: Bool, cellForRowAt indexPath: IndexPath)
}
