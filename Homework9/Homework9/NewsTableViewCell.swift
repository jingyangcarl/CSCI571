//
//  HomeTableViewCell.swift
//  Homework9
//
//  Created by Jing Yang on 4/25/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelSection: UILabel!
    @IBOutlet var buttonBookmark: UIButton!
    
    var id: String!
    var bookmark: Bool = false
    var indexPath: IndexPath!
    var newsBookmarkDelegate: NewsBookmarkDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func DidBookmarkClick(_ sender: Any) {
        self.bookmark = !self.bookmark
        if self.newsBookmarkDelegate != nil {
            self.newsBookmarkDelegate.didBookmarkClickedFromSubView(self.bookmark, cellForRowAt: self.indexPath)
        }
    }
    
}
