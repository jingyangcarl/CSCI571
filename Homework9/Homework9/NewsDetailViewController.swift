//
//  HomeNewsDetailViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/26/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSection: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet var buttonBookmark: UIButton!
    @IBOutlet var buttonTwitter: UIButton!
    
    let guardianKey = "70e39bf2-86c6-4c5f-a252-ab34d91a4946"
    
    var status = NewsDetailStatus()
    var newsBookmarkClickDelegate: ClickFromSubviewDelegate!
    var newsBookmarkOperationDelegate: NewsBookmarkOperationDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonTwitter.setImage(UIImage(named: "twitter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        guard let bookmarkViewController = UIApplication.shared.windows.first!.rootViewController?.children[3].children[0] as? BookmarkViewController else { return }
        self.newsBookmarkOperationDelegate = bookmarkViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // check bookmark
        self.status.key.bookmark = self.newsBookmarkOperationDelegate.existBookmark(id: self.status.key.id)
        self.setBookmark(bookmark: self.status.key.bookmark)
        
        // fetch data
        handleFetch(self)
    }
    
    @objc func handleFetch(_ sender: AnyObject) {
        // show loading spinner
        SwiftSpinner.show("Loading News Detail", animated: true)
        
        // prepare request
        let request = NSMutableURLRequest(url: URL(string: "https://content.guardianapis.com/\(self.status.key.id    )?api-key=\(guardianKey)&show-blocks=all")!)
        
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
                    
                    self.status.value.imageUrl = jsonObject["response"]["content"]["blocks"]["main"]["elements"][0]["assets"][0]["file"].stringValue
                    self.status.value.title = jsonObject["response"]["content"]["webTitle"].stringValue
                    self.status.value.date = jsonObject["response"]["content"]["webPublicationDate"].stringValue
                    self.status.value.section = jsonObject["response"]["content"]["sectionName"].stringValue
                    self.status.value.description = jsonObject["response"]["content"]["blocks"]["body"][0]["bodyHtml"].stringValue
                    self.status.value.url = jsonObject["response"]["content"]["webUrl"].stringValue
                    
                    // reload news cell
                    DispatchQueue.main.async {
                        // do
                        self.setImage(imageUrl: self.status.value.imageUrl)
                        self.setTitle(title: self.status.value.title)
                        self.setSection(section: self.status.value.section)
                        self.setDate(date: self.status.value.date)
                        self.setDescription(description: self.status.value.description)
                        
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
    }
    
    
}

// MARK: - Set Widget Content
extension NewsDetailViewController {
    
    func setBookmark(bookmark: Bool) {
        self.buttonBookmark.setImage(bookmark ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
    }
    
    func setImage(imageUrl: String) {
        if self.status.value.imageUrl.isEmpty {
            self.status.value.imageUrl = "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png"
        }
        if let imageData = try? Data(contentsOf: URL(string: self.status.value.imageUrl)!) {
            if let image = UIImage(data: imageData) {
                self.imageView.image = image;
            }
        }
    }
    
    func setTitle(title: String) {
        self.navigationItem.title = title
        self.labelTitle.text = title
    }
    
    func setSection(section: String) {
        self.labelSection.text = section
    }
    
    func setDate(date: String) {
        let dateFormatterFrom = Foundation.DateFormatter()
        let dateFormatterTo = Foundation.DateFormatter()
        dateFormatterFrom.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatterTo.dateFormat = "dd MMM yyyy"
        self.labelDate.text = dateFormatterTo.string(from: dateFormatterFrom.date(from: date)!)
    }
    
    func setDescription(description: String) {
        self.labelDescription.attributedText = description.htmlToAttributedString
    }
}

// MARK: - Handle Button Click
extension NewsDetailViewController {
    
    @IBAction func didBookmarkClicked(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.buttonBookmark.setImage(self.status.key.bookmark ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
            
            // toast
            self.view.hideAllToasts()
            self.view.makeToast(self.status.key.bookmark ? "Article Bookmarked. Check out the Bookmarks tab to view" : "Article Removed from Bookmarks")
        }
        
        self.status.key.bookmark = !self.status.key.bookmark
        if self.newsBookmarkClickDelegate != nil {
            self.newsBookmarkClickDelegate.didCellBookmarkClickedFromSubview(self.status.key.bookmark, cellForRowAt: self.status.key.indexPath)
        }
    }
    
    @IBAction func didTwitterClicked(_ sender: Any) {
        let tweetText = "Check out this Article!"
        let tweetUrl = self.status.value.url
        let tweetHashtag = "CSCI_571_NewsApp"
        
        let shareUrl = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)&hashtags=\(tweetHashtag)"
        
        guard let url = URL(string: shareUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else { return }
        
        UIApplication.shared.open(url)
    }
    
    @IBAction func didViewMoreClicked(_ sender: Any) {
        guard let url = URL(string: self.status.value.url) else { return }
        UIApplication.shared.open(url)
    }
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
