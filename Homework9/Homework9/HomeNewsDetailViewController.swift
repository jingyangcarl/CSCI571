//
//  HomeNewsDetailViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/26/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeNewsDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSection: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    var status = HomeNewsDetailStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // prepare request
        let request = NSMutableURLRequest(url: URL(string: "https://content.guardianapis.com/\(self.status.dataIn.id    )?api-key=\(self.status.dataIn.apiKey)&show-blocks=all")!)
        
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
                    
                    self.status.dataOut.imageUrl = jsonObject["response"]["content"]["blocks"]["main"]["elements"][0]["assets"][0]["file"].stringValue
                    self.status.dataOut.id = jsonObject["response"]["content"]["id"].stringValue
                    self.status.dataOut.title = jsonObject["response"]["content"]["webTitle"].stringValue
                    self.status.dataOut.date = jsonObject["response"]["content"]["webPublicationDate"].stringValue
                    self.status.dataOut.section = jsonObject["response"]["content"]["sectionName"].stringValue
                    self.status.dataOut.description = jsonObject["response"]["content"]["blocks"]["body"][0]["bodyHtml"].stringValue
                    self.status.dataOut.url = jsonObject["response"]["content"]["webUrl"].stringValue
                    
                    // reload news cell
                    DispatchQueue.main.async {
                        
                        if self.status.dataOut.imageUrl.isEmpty {
                            self.status.dataOut.imageUrl = "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png"
                        }
                        if let imageData = try? Data(contentsOf: URL(string: self.status.dataOut.imageUrl)!) {
                            if let image = UIImage(data: imageData) {
                                self.imageView.image = image;
                            }
                        }
                        
                        self.labelTitle.text = self.status.dataOut.title
                        self.labelSection.text = self.status.dataOut.section
                        
                        let dateFormatterFrom = Foundation.DateFormatter()
                        let dateFormatterTo = Foundation.DateFormatter()
                        dateFormatterFrom.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                        dateFormatterTo.dateFormat = "dd MMM yyyy"
                        let date = dateFormatterFrom.date(from: self.status.dataOut.date)
                        self.labelDate.text = dateFormatterTo.string(from: date!)
                        
                        self.labelDescription.attributedText = self.status.dataOut.description.htmlToAttributedString
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
    
    @IBAction func DidClick(_ sender: Any) {
        guard let url = URL(string: self.status.dataOut.url) else { return }
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
