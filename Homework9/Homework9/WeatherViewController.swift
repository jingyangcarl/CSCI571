//
//  WeatherViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/25/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    // IBOutlet to display JSON data
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelWeather: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    
    // init location manager status
    let locationManager = CLLocationManager()
    var locationManagerTrigger = 0
    
    // status to save current weather data
    var status = [
        "weather": [
            "city": "",
            "state": "",
            "temp": 0.0,
            "main": "",
        ]
    ]
    
    // define weather standard
    enum MainWeather: String {
        case Clear = "clear"
        case Cloudy = "cloudy"
        case Rainy = "rainy"
        case Snowy = "snowy"
        case Sunny = "sunny"
        case Thunder = "thunder"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        return
        
        // trigger to fetch weather data
        locationManagerTrigger = (locationManagerTrigger + 1) % 5
        if locationManagerTrigger != 1 {return}
        
        if let location = locations.first {
            
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                if error == nil {
                    // get current location
                    let readableLocation = placemarks?[0]
                    self.status["weather"]?["city"]? = (readableLocation?.locality)!
                    self.status["weather"]?["state"]? = (readableLocation?.administrativeArea)!
                    
                    // prepare request
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                    let openWeatherKey = "d32dc17259016e9927d18628475376ea"
                    let request = NSMutableURLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longitude.description)&units=metric&appid=\(openWeatherKey)")!)
                    
                    // fetch data from openweathermap
                    URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                        guard let httpResponse = response as? HTTPURLResponse else {
                            // Error
                            return
                        }
                        
                        if httpResponse.statusCode == 200 {
                            // Http success
                            do {
                                // save json as an object
                                let jsonObject = try JSONDecoder().decode(OpenWeather.self, from: data!)
                                
                                // get current weather
                                self.status["weather"]?["temp"]? = jsonObject.main.temp
                                self.status["weather"]?["main"]? = jsonObject.weather[0].main
                                
                                // update UI in main thread
                                DispatchQueue.main.async {
                                    self.labelCity.text = self.status["weather"]?["city"] as? String
                                    self.labelState.text = self.status["weather"]?["state"] as? String
                                    self.labelTemperature.text = "\(self.status["weather"]?["temp"] ?? 0) °C"
                                    self.labelWeather.text = self.status["weather"]?["main"] as? String
                                    
                                    switch self.labelWeather.text?.lowercased() {
                                    case MainWeather.Clear.rawValue:
                                        self.imageWeather.image = UIImage(named: "weather_clear"); break
                                    case MainWeather.Cloudy.rawValue:
                                        self.imageWeather.image = UIImage(named: "weather_cloudy"); break
                                    case MainWeather.Rainy.rawValue:
                                        self.imageWeather.image = UIImage(named: "weather_rainy"); break
                                    case MainWeather.Snowy.rawValue:
                                        self.imageWeather.image = UIImage(named: "weather_snowy"); break
                                    case MainWeather.Sunny.rawValue:
                                        self.imageWeather.image = UIImage(named: "weather_sunny"); break
                                    case MainWeather.Thunder.rawValue:
                                        self.imageWeather.image = UIImage(named: "weather_thunder"); break
                                    default:
                                        self.imageWeather.image = UIImage(named: "weather_sunny"); break
                                    }
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
