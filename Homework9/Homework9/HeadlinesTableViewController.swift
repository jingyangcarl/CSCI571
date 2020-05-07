//
//  HeadlinesTableViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/27/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import SwiftSpinner

class HeadlinesTableViewController: NavigationTableViewController, IndicatorInfoProvider {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.status.newsDict.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "HOME")
    }
    
    @objc override func handleRefresh(_ sender: AnyObject) {
        
        // prepare request
        let request = NSMutableURLRequest(url: URL(string: "http://content.guardianapis.com/\(self.restorationIdentifier! )?api-key=\(guardianKey)&show-blocks=all")!)
        
        return super.handleRefresh(request)
    }

}
