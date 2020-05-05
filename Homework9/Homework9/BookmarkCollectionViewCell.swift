//
//  BookmarkCollectionViewCell.swift
//  Homework9
//
//  Created by Jing Yang on 5/4/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelSection: UILabel!
    @IBOutlet var buttonBookmark: UIButton!
    
    @IBAction func DidBookmarkClick(_ sender: Any) {
        
    }
}
