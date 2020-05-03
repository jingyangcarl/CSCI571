//
//  HomeNewsDetailViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/26/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSection: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    var status = NewsStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // prepare request
        let request = NSMutableURLRequest(url: URL(string: "https://content.guardianapis.com/\(self.status.key.id    )?api-key=\(self.status.key.apiKey)&show-blocks=all")!)
        
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
                        
                        self.navigationItem.title = self.status.value.title
                        
                        if self.status.value.imageUrl.isEmpty {
                            self.status.value.imageUrl = "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png"
                        }
                        if let imageData = try? Data(contentsOf: URL(string: self.status.value.imageUrl)!) {
                            if let image = UIImage(data: imageData) {
                                self.imageView.image = image;
                            }
                        }
                        
                        self.labelTitle.text = self.status.value.title
                        self.labelSection.text = self.status.value.section
                        
                        let dateFormatterFrom = Foundation.DateFormatter()
                        let dateFormatterTo = Foundation.DateFormatter()
                        dateFormatterFrom.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                        dateFormatterTo.dateFormat = "dd MMM yyyy"
                        let date = dateFormatterFrom.date(from: self.status.value.date)
                        self.labelDate.text = dateFormatterTo.string(from: date!)
                        
                        self.labelDescription.attributedText = self.status.value.description.htmlToAttributedString
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
    
    @IBAction func DidBookmarkClick(_ sender: Any) {
    }
    
    @IBAction func DidTwitterClick(_ sender: Any) {
        let tweetText = "Check out this Article!"
        let tweetUrl = self.status.value.url
        let tweetHashtag = "CSCI_571_NewsApp"
        
        let shareUrl = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)&hashtags=\(tweetHashtag)"
        
        guard let url = URL(string: shareUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else { return }
        
        UIApplication.shared.open(url)
    }
    
    @IBAction func DidViewMoreClick(_ sender: Any) {
        guard let url = URL(string: self.status.value.url) else { return }
        UIApplication.shared.open(url)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
}
