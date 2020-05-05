//
//  FourthViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/23/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, NewsBookmarkDetailDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func sendBookmarkedNews(news: String) {
        print(news)
    }
}

protocol NewsBookmarkDetailDelegate {
    func sendBookmarkedNews(news: String)
}
