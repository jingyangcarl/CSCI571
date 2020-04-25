//
//  FirstViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/23/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var locationManagerTrigger = 0
    
    var status = [
        "weather": [
            "city": "",
            "state": "",
        ]
    ]
    
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
                                let jsonObject = try JSONDecoder().decode(OpenWeather.self, from: data!)
                                print(jsonObject.coord.lon)
                                
                                self.performSegue(withIdentifier: "toWeatherViewController", sender: self)
                                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeatherViewController" {
//            guard let weatherViewController = segue.destination as? WeatherViewController else {return}
        }
    }
    
}

