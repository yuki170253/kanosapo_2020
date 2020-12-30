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
    
    var todoArray:[Todo]?
    var titleArray:[[String]] = [[]]
    var rateArray:[[String]] = [[]]
    var selfEvaluationArray:[[String]] = [[]]
    
    let substr : (String, Int, Int) -> String = { text, from, length in
        let to = text.index(text.startIndex, offsetBy:from + length)
        let from = text.index(text.startIndex, offsetBy:from)
        return String(text[from...to])
    }
    
    private var numEntry = 7
    var daylist7 = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        daylist7 = daylist7Reverse()
        print("afnieufnuwanuiwgngnanunuiengawgneugiag")
        print(daylist7)
        
        numEntry = daylist7.count
        for i in 0 ..< daylist7.count {
            let results = realm.objects(Todo.self).filter("datestring == %@", daylist7[i])
            titleArray.append([String]())
            rateArray.append([String]())
            selfEvaluationArray.append([String]())
            for todo in results {
                titleArray[i].append(todo.title)
                rateArray[i].append(String(todo.rate))
                selfEvaluationArray[i].append(String(todo.selfEvaluation))
            }
        }
        print(titleArray)
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
        guard daylist7.count > 0 else { return }
        for _ in 0...daylist7.count-1 {
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
//        let realm = try! Realm()
//        let myTodos = realm.objects(Todo.self)
//        for myTodo in myTodos{
//            print("OkBooooooooooooy")
//            print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
//            print(myTodo.selfEvaluation)
//            print(myTodo.dotime)
//            print(myTodo.title)
//
//        }
    }
    

    func sendValueToSub(index:Int){
        let todayTitle:[String] = titleArray[index]
        ud.set(todayTitle, forKey: "todayTitle")
        let todayRate:[String] = rateArray[index]
        ud.set(todayRate, forKey: "todayRate")
        let todaySelfEvaluation:[String] = selfEvaluationArray[index]
        ud.set(todaySelfEvaluation, forKey: "todaySelfEvaluation")
        dayResultProtocol?.moveCordinate(x1: 29+72*(index-2), y1: 0)
        print("番号：\(index)")
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
        for i in 0..<daylist7.count {
            var s = daylist7[i]
            if s != "指定なし"{
                let arr:[String] = s.components(separatedBy: "年")
                s = arr[1]
            }
            let item = TMBarItem(title: s)
            items.append(item)
        }
        print("おおおおおおおおお")
        print(items.count)
        
        return items[index]
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        initializeViewControllers()
        return viewControllers.count
    }

    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        sendValue()
        
//        if index == 0{
//            menhera = "タスク：\(todotitle)"
//            achivement = "実施時間：\(String(dotime))秒"
//            selfEvaluate = "自己評価：★★★☆"
//            dayResultProtocol?.moveCordinate(x1: 25, y1: 0)
//
//        }
        
//        menhera = titleArray[index]
//        achivement = String(rateArray[index])
//        selfEvaluate = String(selfEvaluationArray[index])
        
        sendValueToSub(index:index)
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
