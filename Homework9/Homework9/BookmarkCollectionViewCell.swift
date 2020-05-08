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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
    }

    
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
        let dateFormatterFrom = Foundation.DateFormatter()
        let dateFormatterTo = Foundation.DateFormatter()
        dateFormatterFrom.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatterTo.dateFormat = "dd MMM yyyy"
        self.labelDate.text = dateFormatterTo.string(from: dateFormatterFrom.date(from: date)!)
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
