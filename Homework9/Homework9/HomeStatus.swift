//
//  HomeViewStatus.swift
//  Homework9
//
//  Created by Jing Yang on 4/25/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import Foundation
import UIKit

struct HomeStatus {
    var weather: WeatherStatus;
    var newsList: [News];
    var selectedNewsIndex: Int;
    
    init() {
        self.weather = WeatherStatus();
        self.newsList = [News]();
        self.selectedNewsIndex = 0;
    }
}

struct WeatherStatus {
    var city: String;
    var state: String;
    var temp: Double;
    var weather: String;
    
    init() {
        self.city = "city";
        self.state = "state";
        self.temp = 0.0;
        self.weather = "weather";
    }
}

struct News {
    var imageUrl: String;
    var image: UIImage;
    var title: String;
    var date: String;
    var section: String;
    var id: String;
    
    init() {
        self.imageUrl = "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png";
        self.image = UIImage()
        self.title = "title"
        self.date = "2020-04-26T03:02:14Z"
        self.section = "section"
        self.id = "id"
        
        if let imageData = try? Data(contentsOf: URL(string: self.imageUrl)!) {
            if let image = UIImage(data: imageData) {
                self.image = image;
            }
        }
    }
    
    init(imageUrl: String, title: String, date: String, section: String, id: String) {
        self.imageUrl = imageUrl;
        self.image = UIImage();
        self.title = title;
        self.date = date;
        self.section = section;
        self.id = id;
        
        if let imageData = try? Data(contentsOf: URL(string: self.imageUrl)!) {
            if let image = UIImage(data: imageData) {
                self.image = image;
            }
        }
    }
}
