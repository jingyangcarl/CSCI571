//
//  FourthViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/23/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, NewsBookmarkDetailDelegate {
    
    var newsDict: [String: News] = [String: News]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addBookmark(id: String, news: News) {
        self.newsDict[id] = news
        print(newsDict.count)
    }
    
    func removeBookmark(id: String) {
        self.newsDict.removeValue(forKey: id)
        print(newsDict.count)
    }
}

protocol NewsBookmarkDetailDelegate {
    func addBookmark(id: String, news: News)
    func removeBookmark(id: String)
}
