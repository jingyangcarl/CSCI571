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
        refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleRefresh(self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "News Cell", for: indexPath) as! NewsTableViewCell

        // Configure the cell...
        if !self.status.newsDict.isEmpty {
            cell.imageThumbnail.image = Array(self.status.newsDict.values)[indexPath.row].image
            cell.labelTitle.text = Array(self.status.newsDict.values)[indexPath.row].title
            cell.labelSection.text = Array(self.status.newsDict.values)[indexPath.row].section

            let dateFormatter = Foundation.DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

            let webPublicationDate = dateFormatter.date(from: Array(self.status.newsDict.values)[indexPath.row].date)
            let timeInterval = webPublicationDate?.timeIntervalSinceNow.exponent
            let days = timeInterval! / 86400;
            let hours = (timeInterval! % 86400) / 3600;
            let minutes = ((timeInterval! % 86400) % 3600) / 60;
            let seconds = ((timeInterval! % 86400) % 3600) % 60;

            if days != 0 {
                cell.labelDate.text = "\(days)d ago";
            } else if hours != 0 {
                cell.labelDate.text = "\(hours)h ago";
            } else if minutes != 0 {
                cell.labelDate.text = "\(minutes)m ago";
            } else {
                cell.labelDate.text = "\(seconds)s ago"
            }
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {suggestedActions in

            let twitterMenu = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter")) { action in
                // share

                let tweetText = "Check out this Article!"
                let tweetUrl = Array(self.status.newsDict.values)[indexPath.row].url
                let tweetHashtag = "CSCI_571_NewsApp"
                
                let shareUrl = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)&hashtags=\(tweetHashtag)"
                
                guard let url = URL(string: shareUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else { return }
                
                UIApplication.shared.open(url)
            }
            let bookMarkMenu = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                //
            }
            
            // Create and return a UIMenu with the share action
            return UIMenu(title: "Main Menu", children: [twitterMenu, bookMarkMenu])
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.status.selectedIndexPath = indexPath
        performSegue(withIdentifier: "NewsDetailSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.status.newsDict.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "HOME")
    }
    
    @objc func handleRefresh(_ ender: AnyObject) {
        print(self.restorationIdentifier!)
        
        // prepare request
        let request = NSMutableURLRequest(url: URL(string: "http://content.guardianapis.com/\(self.restorationIdentifier! )?api-key=\(guardianKey)&show-blocks=all")!)
        
        // fetch data
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                // error
                return
            }
            
            if httpResponse.statusCode == 200 {
                // Http success
                do {
                    // save json as an object
                    let jsonObject = try JSON(data: data!)
                    
                    for (_, result): (String, JSON) in jsonObject["response"]["results"] {
                        let imageUrl: String = result["blocks"]["main"]["elements"][0]["assets"][0]["file"].stringValue
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
                    
                    // reload news cell
                    DispatchQueue.main.async {
                        self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newsDetailViewController = segue.destination as? NewsDetailViewController else { return }
        
        // prepare data will be used in Detail View
        newsDetailViewController.status.key.id = Array(self.status.newsDict.values)[self.status.selectedIndexPath.row].id
        newsDetailViewController.status.key.apiKey = guardianKey
    }

}
