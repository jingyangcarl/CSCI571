//
//  HeadlinesTableViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/27/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HeadlinesTableViewController: UITableViewController, IndicatorInfoProvider {
    
    // status to save current data
    var status = Status()
    
    // api keys
    let guardianKey = "70e39bf2-86c6-4c5f-a252-ab34d91a4946"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // enable pull down to refresh for table view
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl!)
        
        // get current section
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "News Cell", for: indexPath) as! NewsTableViewCell

        // Configure the cell...
        cell.imageView?.image = UIImage(named: "earth")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    @objc func refresh(_ ender: AnyObject) {
        print("refresh")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "HOME")
    }

}
