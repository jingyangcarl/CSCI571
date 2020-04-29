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
    var newsSection: String
    var newsList: [News]
    var selectedNewsIndex: Int
    var weather: Weather
    
    init() {
        self.newsSection = String()
        self.newsList = [News]()
        self.selectedNewsIndex = 0
        self.weather = Weather()
    }
}

struct Weather {
    var city: String;
    var state: String;
    var temp: Double;
    var weather: String;
    
    init() {
        self.city = String();
        self.state = String();
        self.temp = Double();
        self.weather = String();
    }
}

struct News {
    var imageUrl: String;
    var image: UIImage;
    var title: String;
    var date: String;
    var section: String;
    var id: String;
    
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
