//
//  BookmarkCollectionViewCell.swift
//  Homework9
//
//  Created by Jing Yang on 5/4/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    
    var id: String!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelSection: UILabel!
    @IBOutlet var buttonBookmark: UIButton!
    
    var newsBookmarkOperationDelegate: NewsBookmarkOperationDelegate!
    
    @IBAction func didBookmarkClicked(_ sender: Any) {
        // only need to perform bookmark remove
        if newsBookmarkOperationDelegate != nil {
            self.newsBookmarkOperationDelegate.removeBookmark(id: id)
        }
    }
}

extension BookmarkCollectionViewCell {
    
    
    func setId(id: String) {
        self.id = id
    }
    
    func setImage(image: UIImage) {
        self.imageView.image = image;
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
        if bookmark {
            self.buttonBookmark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            self.buttonBookmark.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
}
