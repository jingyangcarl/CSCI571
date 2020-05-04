//
//  ThridViewController.swift
//  Homework9
//
//  Created by Jing Yang on 4/23/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import UIKit
import Charts

class TrendingViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var lineChartView: LineChartView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchBar.delegate = self
        
        setChartValues()
    }
    
    func setChartValues(_ count: Int = 20) {
        let values = (0..<count).map{(i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(UInt32(count)) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set = LineChartDataSet(entries: values, label: "DataSet 1")
        let data = LineChartData(dataSet: set)
        
        self.lineChartView.data = data
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
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
