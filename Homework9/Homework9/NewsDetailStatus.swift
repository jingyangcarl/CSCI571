//
//  HomeNewsDetailStatus.swift
//  Homework9
//
//  Created by Jing Yang on 4/26/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import Foundation
import UIKit

struct NewsDetailStatus {
    var key: Key;
    var value: Value;
    
    init() {
        self.key = Key();
        self.value = Value();
    }
}

struct Key {
    var id: String;
    var apiKey: String;
    
    init() {
        self.id = "";
        self.apiKey = "";
    }
}

struct Value {
    var imageUrl: String;
    var title: String;
    var date: String;
    var section: String;
    var description: String;
    var url: String;
    
    init() {
        self.imageUrl = "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png";
        self.title = "title"
        self.date = "2020-04-26T03:02:14Z"
        self.section = "section"
        self.description = "description"
        self.url = "url"
    }
}
