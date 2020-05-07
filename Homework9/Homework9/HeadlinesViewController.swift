//
//  SecondViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/23/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class HeadlinesViewController: ButtonBarPagerTabStripViewController, ClickOnSubviewDelegate, UISearchBarDelegate {
    
    var autoSuggestTableViewController: AutoSuggestTableViewController!
    var isFirstSearchLetter: Bool = true
    
    let bingKey = "79f5b5a589c74be4aa1d102ca11fadd2"

    override func viewDidLoad() {
        
        // prepare searchbar
        self.navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController?.searchBar.showsCancelButton = true
        self.navigationItem.searchController?.searchBar.delegate = self
        self.navigationItem.searchController?.searchBar.placeholder = "Enter keyword ..."
        
        // initialize
        self.autoSuggestTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "search")
        self.autoSuggestTableViewController.clickOnSubviewDelegate = self
        
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
    
    func didCellClickedOnSubview(cellForRowAt indexPath: IndexPath) {
        guard let cell = self.autoSuggestTableViewController.tableView.cellForRow(at: indexPath) else { return }
        performSegue(withIdentifier: "SearchResultSegue", sender: cell.textLabel?.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if self.isFirstSearchLetter {
            self.navigationItem.searchController?.present(self.autoSuggestTableViewController, animated: true, completion: nil)
            searchBar.becomeFirstResponder()
            self.isFirstSearchLetter = false
        }
        
        let request = NSMutableURLRequest(url: URL(string: "https://api.cognitive.microsoft.com/bing/v7.0/suggestions?q=\(searchText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.setValue(bingKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        // fetch data
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 200 {
                // Http success
                do {
                    // save json as an object
                    let jsonObject = try JSON(data: data!)
                    
                    self.autoSuggestTableViewController.suggestions.removeAll()
                    
                    for (_, suggestion): (String, JSON) in jsonObject["suggestionGroups"][0]["searchSuggestions"] {
                        self.autoSuggestTableViewController.suggestions.append(suggestion["query"].stringValue)
                    }
                    
                    DispatchQueue.main.async {
                        self.autoSuggestTableViewController.tableView.reloadData()
                    }
                    
                    
                } catch DecodingError.dataCorrupted(let context) {
                    print(context.debugDescription)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("\(key.stringValue) was not found, \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("\(type) was expected, \(context.debugDescription)")
                } catch DecodingError.valueNotFound(let type, let context) {
                    print("no value was found for \(type), \(context.debugDescription)")
                } catch let error {
                    print(error)
                }
            } else {
                // Http error
            }
            
        }.resume()
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isFirstSearchLetter = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

}

