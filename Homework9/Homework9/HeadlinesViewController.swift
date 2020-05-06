//
//  SecondViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/23/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HeadlinesViewController: ButtonBarPagerTabStripViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        
        // prepare searchbar
        self.navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController?.searchBar.showsCancelButton
        self.navigationItem.searchController?.searchBar.delegate = self
        self.navigationItem.searchController?.searchBar.placeholder = "Enter keyword ..."
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .systemBlue
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0

        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else {return}
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .systemBlue
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let worldTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "world")
        let businessTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "business")
        let politicsTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "politics")
        let sportsTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "sport")
        let technologyTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "technology")
        let scienceTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "science")

        return [worldTable, businessTable, politicsTable, sportsTable, technologyTable, scienceTable]
    }

}

