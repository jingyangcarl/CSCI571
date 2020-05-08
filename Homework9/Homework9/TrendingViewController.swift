//
//  ThridViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/23/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class TrendingViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var lineChartView: LineChartView!
    @IBOutlet var searchBar: UISearchBar!
    
    var chartDataEntries: [ChartDataEntry]!
    var keyword: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.searchBar.delegate = self
        
        searchBarSearchButtonClicked(self.searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.keyword = searchBar.text == "" ? "coronavirus": searchBar.text!
        
        // prepare request
        let request = NSMutableURLRequest(url: URL(string: "http://ec2-3-22-175-5.us-east-2.compute.amazonaws.com:5000/trending/\(self.keyword!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        
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
                    
                    self.chartDataEntries = [ChartDataEntry]()
                    for (index, result): (String, JSON) in jsonObject["default"]["timelineData"] {
                        self.chartDataEntries.append(ChartDataEntry(x: (index as NSString).doubleValue, y: result["value"][0].double!))
                    }
                    let dataSet = LineChartDataSet(entries: self.chartDataEntries, label: "Trending Chart for \(self.keyword!)")
                    let data = LineChartData(dataSet: dataSet)
                    
                    // reload news cell
                    DispatchQueue.main.async {
                        self.lineChartView.data = data
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
        
        searchBar.endEditing(true)
    }
    
}
