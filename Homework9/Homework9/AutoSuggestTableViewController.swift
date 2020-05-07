//
//  AutoSuggestTableViewController.swift
//  Homework9
//
//  Created by Jing Yang on 5/6/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit

class AutoSuggestTableViewController: UITableViewController {
    
    var suggestions: [String]!
    var clickOnSubviewDelegate: ClickOnSubviewDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.suggestions = [String]()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.suggestions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Suggection Cell", for: indexPath)
        cell.textLabel?.text = suggestions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.clickOnSubviewDelegate != nil {
            self.clickOnSubviewDelegate.didCellClickedOnSubview(cellForRowAt: indexPath)
        }
    }
}
