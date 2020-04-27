//
//  HomeNewsDetailStatus.swift
//  Homework9
//
//  Created by Jing Yang on 4/26/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import Foundation
import UIKit

struct HomeNewsDetailStatus {
    var dataIn: DataIn;
    var dataOut: DataOut;
    
    init() {
        self.dataIn = DataIn();
        self.dataOut = DataOut();
    }
}

struct DataIn {
    var id: String;
    var apiKey: String;
    
    init() {
        self.id = "";
        self.apiKey = "";
    }
}

struct DataOut {
    var imageUrl: String;
    var image: UIImage;
    var title: String;
    var time: String;
    var section: String;
    var id: String;
    var content: String;
    
    init() {
        self.imageUrl = "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png";
        self.image = UIImage()
        self.title = "title"
        self.time = "2020-04-26T03:02:14Z"
        self.section = "section"
        self.id = "id"
        self.content = "content"
        
        if let imageData = try? Data(contentsOf: URL(string: self.imageUrl)!) {
            if let image = UIImage(data: imageData) {
                self.image = image;
            }
        }
    }
}
