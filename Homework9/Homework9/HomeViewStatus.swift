//
//  HomeViewStatus.swift
//  Homework9
//
//  Created by Jing Yang on 4/25/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import Foundation
import UIKit

struct Status {
    var weather: WeatherStatus;
    var newsList: [News];
    
    init() {
        weather = WeatherStatus();
        newsList = [News]();
    }
}

struct WeatherStatus {
    var city: String;
    var state: String;
    var temp: Double;
    var weather: String;
    
    init() {
        city = "city";
        state = "state";
        temp = 0.0;
        weather = "weather";
    }
}

struct News {
    var imageUrl: String;
    var image: UIImage;
    var title: String;
    var time: String;
    var section: String;
    var id: String;
    
    init() {
        imageUrl = "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png";
        image = UIImage()
        title = "title"
        time = "2020-04-26T03:02:14Z"
        section = "section"
        id = "id"
    }
    
    init(imageUrl: String, title: String, time: String, section: String, id: String) {
        self.imageUrl = imageUrl;
        self.image = UIImage();
        self.title = title;
        self.time = time;
        self.section = section;
        self.id = id;
        
        if let imageData = try? Data(contentsOf: URL(string: self.imageUrl)!) {
            if let image = UIImage(data: imageData) {
                self.image = image;
            }
        }
    }
}
