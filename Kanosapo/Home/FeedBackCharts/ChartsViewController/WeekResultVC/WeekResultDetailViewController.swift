//
//  WeekResultDetailViewController.swift
//  MyTodoList
//
//  Created by yanagimachi_riku on 2019/12/03.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import Tabman
import Pageboy


class WeekResultDetailViewController: TabmanViewController {
    
    
    var ud = UserDefaults.standard

    
    let dayResult = DayResultViewController()
    
    private let numEntry = 10
    

    
    override func viewDidLoad() {
        super.viewDidLoad()


        print("first")
        loadData()
    }
    
    var viewControllers = [UIViewController]()
    
//    private lazy var viewControllers: [UIViewController] = {
//        [
//            storyboard!.instantiateViewController(withIdentifier: "SubDayResultDetailViewController")
//        ]
//    }()
    
func initializeViewControllers() {
    // Add ViewControllers
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    //viewControllers.removeAll()
    guard numEntry > 0 else { return }
    for _ in 0...numEntry-1 {
        let SubWeekResultDetailVC = storyboard.instantiateViewController(withIdentifier: "SubWeekResultDetailViewController") as! SubWeekResultDetailViewController
        viewControllers.append(SubWeekResultDetailVC)
    }
    
}
    
    //let today:[String:String] = ["menheraMeter":"100%", "achivementTime":"2h30m", "selfValue":"amazing"]
    var menhera = "100%"
    var achivement = "2h30m"
    var selfEvaluate = "amazing"

    func sendValue(){
        let today:[String] = [menhera, achivement, selfEvaluate]
        ud.set(today, forKey: "today")
        print("あああああああああああああ\(today)")
        
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let nextVC = storyboard.instantiateViewController(withIdentifier: "SubDayResultDetailViewController")
//        if let secondVC = nextVC as? SubDayResultDetailViewController {
//            secondVC.menheraMeter = menhera
//
//        }
    }
    
    
    func loadData(){
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        if bars.count < 0 {
            removeBar(bars.first!)
        }
        bar.backgroundView.style = .flat(color: .white)
        bar.layout.contentMode = .intrinsic
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        bar.layout.transitionStyle = .snap
        bar.indicator.tintColor = .systemPink
            
        
        addBar(bar, dataSource: self, at:.top)

        bar.buttons.customize { (button) in
            button.selectedTintColor = .systemPink
        }
    }
}

extension WeekResultDetailViewController: PageboyViewControllerDataSource, TMBarDataSource {
  
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var items = [TMBarItem]()
        var title:String?
        for i in 0..<numEntry {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            title = formatter.string(from: date)
            let item = TMBarItem(title: title!)
            items.append(item)
        }
        return items[index]
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        initializeViewControllers()
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
 
        if index == 4{
            menhera = "50%だよ"
            achivement = "1000000h"
            selfEvaluate = "FIVESTARS"
        }
        print("番号：\(index)")
        sendValue()
        
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
//
//  WeekResultDetailViewController.swift
//  Kanosapo
//
//  Created by 牧内秀介 on 2020/11/17.
//

import Foundation
