//
//  HomeTableViewCell.swift
//  Homework9
//
//  Created by Jing Yang on 4/25/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit

class HomeNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelSection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
