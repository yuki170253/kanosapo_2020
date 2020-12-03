//
//  WeekResultViewController.swift
//  MyTodoList
//
//  Created by yanagimachi_riku on 2019/12/03.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

class WeekResultViewController: UIViewController {

    @IBOutlet var curvedLineChart: BasicLineChart!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            self.view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            let dataEntries = generateRandomEntries()
        
            
            curvedLineChart.dataEntries = dataEntries
            curvedLineChart.isCurved = false
        }
        
        private func generateRandomEntries() -> [PointEntry] {
            var result: [PointEntry] = []
            for i in 0..<100 {
                let value = Int(arc4random() % 500)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMM"
                var date = Date()
                date.addTimeInterval(TimeInterval(24*60*60*i))
                
                result.append(PointEntry(value: value, label: formatter.string(from: date)))
            }
            return result
        }
        
        
        
    //    @IBAction func backToAchive(){
    //        self.dismiss(animated: true, completion: nil)
    //    }
    }
//
//  WeekResultViewController.swift
//  Kanosapo
//
//  Created by 牧内秀介 on 2020/11/17.
//

import Foundation
