//
//  HomeNewsDetailViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/26/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit

class HomeNewsDetailViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    
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
                    let jsonObject = try JSONDecoder().decode(GuardianHomeDetail.self, from: data!)
                    self.status.dataOut.id = jsonObject.response.content.id
                    self.status.dataOut.title = jsonObject.response.content.webTitle
                    self.status.dataOut.date = jsonObject.response.content.webPublicationDate
                    self.status.dataOut.section = jsonObject.response.content.sectionName
                    self.status.dataOut.description = jsonObject.response.content.blocks.body[0]?.bodyHtml ?? ""
                    self.status.dataOut.url = jsonObject.response.content.webUrl
                    
                    // reload news cell
                    DispatchQueue.main.async {
                        self.labelTitle.text = self.status.dataOut.title
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
