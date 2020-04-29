//
//  WorldTableViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/26/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class WorldTableViewController: HeadlinesTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "WORLD")
    }
}
