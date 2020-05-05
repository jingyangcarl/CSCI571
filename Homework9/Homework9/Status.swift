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
    var newsDict: [String: News]
//    var selectedNewsIndex: Int
    var selectedIndexPath: IndexPath
    var weather: Weather
    
    init() {
        self.newsDict = [String: News]()
//        self.selectedNewsIndex = 0
        self.selectedIndexPath = IndexPath()
        self.weather = Weather()
    }
}

struct Weather {
    var city: String
    var state: String
    var temp: Double
    var weather: String
    
    init() {
        self.city = String()
        self.state = String()
        self.temp = Double()
        self.weather = String()
    }
}

struct News {
    var imageUrl: String
    var image: UIImage
    var title: String
    var date: String
    var section: String
    var id: String
    var url: String
    var bookmark: Bool
    
    init(imageUrl: String, title: String, date: String, section: String, id: String, url: String) {
        self.imageUrl = imageUrl
        self.image = UIImage()
        self.title = title
        self.date = date
        self.section = section
        self.id = id
        self.url = url
        self.bookmark = false
        
        if self.imageUrl.isEmpty {
            self.imageUrl = "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png"
        }
        if let imageData = try? Data(contentsOf: URL(string: self.imageUrl)!) {
            if let image = UIImage(data: imageData) {
                self.image = image
            }
        }
    }
}
