//
//  FourthViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/23/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NewsBookmarkDetailDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var newsDict: [String: News] = [String: News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newsDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Bookmark Cell", for: indexPath) as! BookmarkCollectionViewCell
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func addBookmark(id: String, news: News) {
        self.newsDict[id] = news
        collectionView.reloadData()
    }
    
    func removeBookmark(id: String) {
        self.newsDict.removeValue(forKey: id)
        collectionView.reloadData()
    }
}

protocol NewsBookmarkDetailDelegate {
    func addBookmark(id: String, news: News)
    func removeBookmark(id: String)
}
