//
//  SubDayResultDetailViewController.swift
//  MyTodoList
//
//  Created by yanagimachi_riku on 2019/12/02.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

class SubDayResultDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var tabman = tabmanDisplay()
    
    var ud = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
    var transMiller = CGAffineTransform()
    var todayTitle:[String] = []
    var todayRate:[String] = []
    var todaySelfEvaluation:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
//        self.view.addSubview(tabman.menheraLabel)
//        tabman.menheraLabel.frame = CGRect(x: 40, y: 80, width: 200, height: 30)
//
//        self.view.addSubview(tabman.achivedLabel)
//        tabman.achivedLabel.frame = CGRect(x: 40, y: 135, width: 200, height: 30)
//
//        self.view.addSubview(tabman.evaluatedLabel)
//        tabman.evaluatedLabel.frame = CGRect(x: 40, y: 185, width: 200, height: 30)
        
        
        transMiller = CGAffineTransform(scaleX: -1.5, y: 1.5)
        //if メンヘラのゲージ > 50 {
//        self.view.addSubview(tabman.menhera0Pic)
//        tabman.menhera0Pic.frame = CGRect(x: 206, y: 125, width: 140, height: 113)
//        tabman.menhera0Pic.transform = transMiller
        //}else{
//        self.view.addSubview(tabman.menhera100Pic)
//        tabman.menhera100Pic.frame = CGRect(x: 206, y: 125, width: 140, height: 113)
//        tabman.menhera100Pic.transform = transMiller
        //}
        
        let headerCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "feedbackHeader")!
        let headerView: UIView = headerCell.contentView
        tableView.tableHeaderView = headerView
        self.view.bringSubviewToFront(tableView)
        
        
        self.todayTitle = ud.array(forKey: "todayTitle") as! [String]
        self.todayRate = ud.array(forKey: "todayRate") as! [String]
        self.todaySelfEvaluation = ud.array(forKey: "todaySelfEvaluation") as! [String]
        
        
        
        print("second")
//        tabman.menheraLabel.text = getToday[0]
//        tabman.achivedLabel.text = getToday[1]
//        tabman.evaluatedLabel.text = getToday[2]
        print(todayTitle)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedback", for: indexPath) as! feedbackTableViewCell
        // セルに表示する値を設定する
        
        
        cell.feedbackset(title: "\(todayTitle[indexPath.row])", rate: "\(todayRate[indexPath.row])", evaluation: "\(todaySelfEvaluation[indexPath.row])")
        
        //todayTitle[indexPath.row]
        return cell
    }
}
