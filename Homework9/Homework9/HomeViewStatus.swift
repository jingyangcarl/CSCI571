//
//  HomeViewStatus.swift
//  Homework9
//
//  Created by Jing Yang on 4/25/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import Foundation

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
    var image: String;
    var title: String;
    var time: String;
    var section: String;
    var id: String;
    
    init() {
        image = "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png";
        title = "title"
        time = "2020-04-26T03:02:14Z"
        section = "section"
        id = "id"
    }
    
    init(image: String, title: String, time: String, section: String, id: String) {
        self.image = image;
        self.title = title;
        self.time = time;
        self.section = section;
        self.id = id;
    }
}
