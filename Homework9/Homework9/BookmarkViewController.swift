//
//  FourthViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/23/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NewsBookmarkDetailDelegate {
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Bookmark Cell", for: indexPath) as! BookmarkCollectionViewCell
        
        if !self.newsDict.isEmpty {
            cell.imageView.image = Array(self.newsDict.values)[indexPath.row].image
            cell.labelTitle.text = Array(self.newsDict.values)[indexPath.row].title
            cell.labelSection.text = Array(self.newsDict.values)[indexPath.row].section

            let dateFormatter = Foundation.DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

            let webPublicationDate = dateFormatter.date(from: Array(self.newsDict.values)[indexPath.row].date)
            let timeInterval = webPublicationDate?.timeIntervalSinceNow.exponent
            let days = timeInterval! / 86400;
            let hours = (timeInterval! % 86400) / 3600;
            let minutes = ((timeInterval! % 86400) % 3600) / 60;
            let seconds = ((timeInterval! % 86400) % 3600) % 60;

            if days != 0 {
                cell.labelDate.text = "\(days)d ago";
            } else if hours != 0 {
                cell.labelDate.text = "\(hours)h ago";
            } else if minutes != 0 {
                cell.labelDate.text = "\(minutes)m ago";
            } else {
                cell.labelDate.text = "\(seconds)s ago"
            }
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func addBookmark(id: String, news: News) {
        self.newsDict[id] = news
        collectionView?.reloadData()
    }
    
    func removeBookmark(id: String) {
        self.newsDict.removeValue(forKey: id)
        collectionView?.reloadData()
    }
}

protocol NewsBookmarkDetailDelegate {
    func addBookmark(id: String, news: News)
    func removeBookmark(id: String)
}
