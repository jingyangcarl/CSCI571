//
//  NavigationTableViewController.swift
//  Homework9
//
//  Created by Jing Yang on 5/6/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class NavigationTableViewController: UITableViewController, ClickFromSubviewDelegate {
    
    // status to save current data
    var status = Status()
    
    // api keys
    let guardianKey = "70e39bf2-86c6-4c5f-a252-ab34d91a4946"
    
    var newsBookmarkOperationDelegate: NewsBookmarkOperationDelegate!
    
    enum SegueIdentifier: String {
        case NewsDetail = "NewsDetailSegue"
        case SearchResult = "SearchResultSegue"
    }
    
    var sessionIdentifier: [String: Int] = [
        "news": 0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // enable pull down to refresh for table view
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl!)
        
        // init bookmark delegte, since Bookmark View Controler will not load early than Home View Controller, initialization should be done here
        guard let bookmarkViewController = UIApplication.shared.windows.first!.rootViewController?.children[3].children[0] as? BookmarkViewController else { return }
        self.newsBookmarkOperationDelegate = bookmarkViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleRefresh(self)
    }
    
    /*
     This function will be called in the derived class with a instantized request, which is necessary
     */
    @objc func handleRefresh(_ sender: AnyObject) {
        guard let request = sender as? NSMutableURLRequest else { return }
        guard let section = self.restorationIdentifier else { return }
        
        // show loading page
        SwiftSpinner.show("Loading \(section.capitalizingFirstLetter()) Page", animated: true)
        
        // fetch data
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 200 {
                // Http success
                do {
                    // save json as an object
                    let jsonObject = try JSON(data: data!)
                    
                    for (_, result): (String, JSON) in jsonObject["response"]["results"] {
                        
                        // imageUrl are saved in difference location in different section
                        let imageUrl: String = section == "home" ? result["fields"]["thumbnail"].stringValue : result["blocks"]["main"]["elements"][0]["assets"][0]["file"].stringValue
                        
                        let title: String = result["webTitle"].stringValue
                        let date: String = result["webPublicationDate"].stringValue
                        let section: String = result["sectionId"].stringValue
                        let id: String = result["id"].stringValue
                        let url: String = result["webUrl"].stringValue
                        
                        if self.status.newsDict[id] == nil {
                            let news: News = News(imageUrl: imageUrl, title: title, date: date, section: section, id: id, url: url)
                            self.status.newsDict[id] = news
                        }
                    }
                    
                    DispatchQueue.main.async {
                        // reload news cell
                        self.tableView.reloadData()
                        // hide loading spinner
                        SwiftSpinner.hide()
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
        
        self.refreshControl?.endRefreshing()
    }
    
    /*
     This function defines commonly used preparation for segue, customized segue should be defined in the derived class
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.NewsDetail.rawValue {
            guard let newsDetailViewController = segue.destination as? NewsDetailViewController else { return }
            guard let indexPath = sender as? IndexPath else { return }
            
            // prepare data will be used in Detail View
            newsDetailViewController.status.key.id = Array(self.status.newsDict.values)[indexPath.row].id
            newsDetailViewController.status.key.indexPath = indexPath
            newsDetailViewController.newsBookmarkClickDelegate = self
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == self.sessionIdentifier["news"] {
            
            // prepare cell and news
            let cell = tableView.dequeueReusableCell(withIdentifier: "News Cell", for: indexPath) as! NewsTableViewCell
            var news = Array(self.status.newsDict.values)[indexPath.row]
            
            // update bookmark statua based on the current bookmark database
            news.bookmark = self.newsBookmarkOperationDelegate.existBookmark(id: news.id)
            self.status.newsDict[news.id]?.bookmark = news.bookmark
            
            // load cell
            cell.setNews(news: news, indexPath: indexPath)
            
            // assign delegate
            cell.newsBookmarkClickDelegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {suggestedActions in
            
            var news: News = Array(self.status.newsDict.values)[indexPath.row]
            
            let twitterMenu = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter")) { action in
                // share
                
                let tweetText = "Check out this Article!"
                let tweetUrl = news.url
                let tweetHashtag = "CSCI_571_NewsApp"
                
                let shareUrl = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)&hashtags=\(tweetHashtag)"
                
                guard let url = URL(string: shareUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else { return }
                
                UIApplication.shared.open(url)
            }
            let bookmarkMenu = UIAction(title: "Bookmark", image: news.bookmark ?  UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")) { action in
                //
                news.bookmark = !news.bookmark
                self.didCellBookmarkClickedFromSubview(news.bookmark, cellForRowAt: indexPath)
            }
            
            // Create and return a UIMenu with the share action
            return UIMenu(title: "Main Menu", children: [twitterMenu, bookmarkMenu])
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == self.sessionIdentifier["news"] {
            performSegue(withIdentifier: "NewsDetailSegue", sender: indexPath)
        }
    }
}

protocol ClickFromSubviewDelegate {
    func didCellBookmarkClickedFromSubview(_ bookmark: Bool, cellForRowAt indexPath: IndexPath)
}

extension NavigationTableViewController {
    
    func didCellBookmarkClickedFromSubview(_ bookmark: Bool, cellForRowAt indexPath: IndexPath) {
        
        guard let cell = self.tableView.cellForRow(at: indexPath) as? NewsTableViewCell else { return }
        
        // update bookmark UI
        self.status.newsDict[cell.id]?.bookmark = bookmark
        DispatchQueue.main.async {
            cell.buttonBookmark.setImage(bookmark ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
        }
        
        // update bookmark collection view
        if self.newsBookmarkOperationDelegate != nil {
            if bookmark {
                self.newsBookmarkOperationDelegate.addBookmark(id: cell.id, news: self.status.newsDict[cell.id]!)
                
                // toast
                self.parent?.view.hideAllToasts()
                self.parent?.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")
            } else {
                self.newsBookmarkOperationDelegate.removeBookmark(id: cell.id)
                
                // toast
                self.parent?.view.hideAllToasts()
                self.parent?.view.makeToast("Article Removed from Bookmarks")
            }
        }
    }
}
