//
//  DayResultDetailViewController.swift
//  MyTodoList
//
//  Created by yanagimachi_riku on 2019/12/01.
//  Copyright © 2019 古府侑樹. All rights reserved.
//


import UIKit
import Tabman
import Pageboy
import RealmSwift


protocol DayResultDelegate: class{
    func moveCordinate(x1:Int, y1:Int)
}

class DayResultDetailViewController: TabmanViewController {
    
    var ud = UserDefaults.standard

    var somethingX: Int?
    
    var moveChart:Int!
    
    weak var dayResultProtocol: DayResultDelegate?
    
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
            let SubDayResultDetailVC = storyboard.instantiateViewController(withIdentifier: "SubDayResultDetailViewController") as! SubDayResultDetailViewController
            viewControllers.append(SubDayResultDetailVC)
        }
    }
    
    
    var todoListArray = [MyTodo]()
    var myTodo :MyTodo?
    
    var index: Int = 0
    var indexs: [Int] = []
    
    
    var x: Double = 0
    var sepatime:[Int] = []
    //var evaluation:[Double] = []
    var evaluation:Int = 0
    var dotime:Int = 0
    var todotitle:String = ""
    
    var taskName:String = ""
    var menhera:String = ""
    var achivement:String = ""
    var selfEvaluate:String = ""


    
    func sendValue(){
        let realm = try! Realm()
        let myTodos = realm.objects(Todo.self)
        for myTodo in myTodos{
            if myTodo.todoDone == true{
                print("OkBooooooooooooy")
                                
//                if let unevaluation:Int = myTodo.rate {
//                    evaluation = unevaluation
//                }
//                if let undotime:Int = myTodo.dotime{
//                    dotime = undotime
//                }
//                if let untitle:String = myTodo.title{
//                    todotitle = untitle
//                }
            }else{
                print("まだ終わってない")
            }
        }
        
   
    }
    

    func sendValueToSub(){
        let today:[String] = [menhera, achivement, selfEvaluate]
        ud.set(today, forKey: "today")
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

extension DayResultDetailViewController: PageboyViewControllerDataSource, TMBarDataSource {
  
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
        sendValue()
        if index == 0{
            menhera = "タスク：\(todotitle)"
            achivement = "実施時間：\(String(dotime))秒"
            selfEvaluate = "自己評価：★★★☆"
            dayResultProtocol?.moveCordinate(x1: 25, y1: 0)
             
        }else if index == 1 {
            menhera = "タスク：\(todotitle)"
            achivement = "実施時間：\(String(dotime))秒"
            selfEvaluate = "自己評価：★★★★"
            dayResultProtocol?.moveCordinate(x1: 25, y1: 0)
            
        }else if index == 2 {
            menhera = "メンヘラ度：20%"
            achivement = "実施時間：1h20m"
            selfEvaluate = "自己評価：★★☆☆"
            dayResultProtocol?.moveCordinate(x1: 29, y1: 0)
            
        }else if index == 3 {
            menhera = "メンヘラ度：90%"
            achivement = "実施時間：3h05m"
            selfEvaluate = "自己評価：★☆☆☆"
            dayResultProtocol?.moveCordinate(x1: 29+72*(index-2), y1: 0)
            
        }else if index == 4 {
            menhera = "メンヘラ度：95%"
            achivement = "実施時間：1h30m"
            selfEvaluate = "自己評価：★★★☆"
            dayResultProtocol?.moveCordinate(x1: 29+72*(index-2), y1: 0)
            
        }else{
            menhera = "これ以降同じ"
            achivement = "実施時間：1h30m"
            selfEvaluate = "自己評価：★★★☆"
            dayResultProtocol?.moveCordinate(x1: 29+72*(index-2), y1: 0)
        }
        print("番号：\(index)")
        
        
        
        sendValueToSub()
        
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
