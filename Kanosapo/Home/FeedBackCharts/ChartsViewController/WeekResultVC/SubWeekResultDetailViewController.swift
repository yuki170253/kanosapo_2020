//
//  SubWeekResultDetailViewController.swift
//  MyTodoList
//
//  Created by yanagimachi_riku on 2019/12/03.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit


class SubWeekResultDetailViewController: UIViewController {
   var tabman = tabmanDisplay()
           
           var ud = UserDefaults.standard
           
           var transMiller = CGAffineTransform()
           
           override func viewDidLoad() {
               super.viewDidLoad()
               
               self.view.addSubview(tabman.menheraLabel)
               tabman.menheraLabel.frame = CGRect(x: 40, y: 80, width: 200, height: 30)
               
               self.view.addSubview(tabman.achivedLabel)
               tabman.achivedLabel.frame = CGRect(x: 40, y: 135, width: 200, height: 30)
               
               self.view.addSubview(tabman.evaluatedLabel)
               tabman.evaluatedLabel.frame = CGRect(x: 40, y: 185, width: 200, height: 30)
               
               
               transMiller = CGAffineTransform(scaleX: -1.5, y: 1.5)
               //if メンヘラのゲージ > 50 {
       //        self.view.addSubview(tabman.menhera0Pic)
       //        tabman.menhera0Pic.frame = CGRect(x: 206, y: 125, width: 140, height: 113)
       //        tabman.menhera0Pic.transform = transMiller
               //}else{
               self.view.addSubview(tabman.menhera100Pic)
               tabman.menhera100Pic.frame = CGRect(x: 206, y: 125, width: 140, height: 113)
               tabman.menhera100Pic.transform = transMiller
               //}
               

               
               let getToday:[String] = ud.array(forKey: "today") as! [String]
               print("second")
               tabman.menheraLabel.text = getToday[0]
               tabman.achivedLabel.text = getToday[1]
               tabman.evaluatedLabel.text = getToday[2]
               print(getToday)
           }
           
    
}
