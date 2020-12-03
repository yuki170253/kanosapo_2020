//
//  ConfirmationViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/09/22.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDetail = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConfirmationTableViewCell
        
        
        cellDetail.valueOfAchievement = rate

        
        cellDetail.taskNameLabel.text = ""
        
//        cellDetail.percentageLabel.text = ""
        
        
        cellDetail.averageDataLabel.text = ""
        
        cellDetail.averageLabel.text = ""
        

        cellDetail.trackLayerValue()
        cellDetail.shapeLayerValue()
        
        cellDetail.loadGraph()
        
        
        return cellDetail
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
    }
    
    
    var myTodo: MyTodo?
    var sepatime: [Int] = []
    var evaluation: [Double] = []
    var x: Double = 0
    var rate: Double = 0
    var dotime: Int = 0
    var todotitle: String = ""
    
    @IBOutlet weak var evalu: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ConfirmationViewControllerに遷移")
        if let unsepatime = myTodo?.sepatime{
            sepatime = unsepatime
        }
        if let unevaluation = myTodo?.evaluation {
            evaluation = unevaluation
        }
        if let undotime = myTodo?.dotime{
            dotime = undotime
        }
        if let untitle = myTodo?.todoTitle{
            todotitle = untitle
        }
        for i in 0..<sepatime.count {
            print("sepatime: \(sepatime[i])")
            print("evaluation: \(evaluation[i])")
            x += Double(sepatime[i]) * evaluation[i]
        }
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.register(UINib(nibName: "ConfirmationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        
        myTableView.tableFooterView = UIView()
        
        
        
        print("This")
        print("dotime=\(Double(dotime))")
        print("x=\(x)")
        rate = (x/Double(dotime))*100
        print(rate)
       
//åååååBUG
        evalu.text = "実施時間：\(String(ceil(rate)))"
        print("タイトル：\(todotitle)")
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        performSegue(withIdentifier: "from_confirmation", sender: nil)
    }
}
