//
//  HomeTableViewCell.swift
//  Homework9
//
//  Created by Jing Yang on 4/25/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    var id: String!
    var bookmark: Bool = false
    var indexPath: IndexPath!

    @IBOutlet var imageThumbnail: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelSection: UILabel!
    @IBOutlet var buttonBookmark: UIButton!
    
    var newsBookmarkDelegate: NewsBookmarkDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didBookmarkClicked(_ sender: Any) {
        self.bookmark = !self.bookmark
        if self.newsBookmarkDelegate != nil {
            self.newsBookmarkDelegate.didBookmarkClickedFromSubView(self.bookmark, cellForRowAt: self.indexPath)
        }
    }
    
}

extension NewsTableViewCell {
    
    func setNews(news: News, indexPath: IndexPath) {
        setId(id: news.id)
        setIndexPath(indexPath: indexPath)
        setImage(image: news.image)
        setTitle(title: news.title)
        setDate(date: news.date)
        setSection(section: news.section)
        setBookmark(bookmark: news.bookmark)
    }
    
    func setId(id: String){
        self.id = id
    }
    
    func setIndexPath(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    func setImage(image: UIImage) {
        if self.imageThumbnail == nil {
            self.imageThumbnail = UIImageView(image: image)
        } else {
            self.imageThumbnail.image = image
        }
    }
    
    func setTitle(title: String) {
        self.labelTitle.text = title
    }
    
    func setDate(date: String) {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        let webPublicationDate = dateFormatter.date(from: date)
        let timeInterval = webPublicationDate?.timeIntervalSinceNow.exponent
        let days = timeInterval! / 86400;
        let hours = (timeInterval! % 86400) / 3600;
        let minutes = ((timeInterval! % 86400) % 3600) / 60;
        let seconds = ((timeInterval! % 86400) % 3600) % 60;
        
        if days != 0 {
            self.labelDate.text = "\(days)d ago";
        } else if hours != 0 {
            self.labelDate.text = "\(hours)h ago";
        } else if minutes != 0 {
            self.labelDate.text = "\(minutes)m ago";
        } else {
            self.labelDate.text = "\(seconds)s ago"
        }
    }
    
    func setSection(section: String) {
        self.labelSection.text = section
    }
    
    func setBookmark(bookmark: Bool) {
        self.bookmark = bookmark
        self.buttonBookmark.setImage(self.bookmark ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
    }
}
