//
//  DayResultViewController.swift
//  MyTodoList
//
//  Created by yanagimachi_riku on 2019/11/29.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import RealmSwift

class DayResultViewController: UIViewController {

    var ud = UserDefaults.standard
    
    var dayResultDetail: DayResultDetailViewController!
    
    var xx: Int?

    
    @IBOutlet weak var barChart: BasicBarChart!
    
    let customContainer = UIView()
    
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
    
    
    var num:Int?
    private let numEntry = 7
    var rateAverage:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayResultDetail = self.children[0] as? DayResultDetailViewController
        
        dayResultDetail.dayResultProtocol = self
        
        let realm = try! Realm()
        let daylist7 = daylist7Reverse()
        var average:Int = 0
        for i in 0 ..< daylist7.count {
            let results = realm.objects(Todo.self).filter("datestring == %@", daylist7[i])
            average = 0
            for todo in results {
                average += todo.rate
            }
            if results.count == 0{
                self.rateAverage.append(0)
            }else{
                self.rateAverage.append(average/results.count)
            }
        }
        self.view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        print("8888888888888888888888888888888888888")
        print(rateAverage)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(false, animated: false)

//画面遷移したときのアニメーションのための関数利用
        let dataEntries = generateEmptyDataEntries()
        barChart.updateDataEntries(dataEntries: dataEntries, animated: false)
//timerで毎回変化させるの邪魔。リロードに変えよう
 //       let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) {[weak self] (timer) in

        let dataEntries2 = generateRandomDataEntries()
        barChart.updateDataEntries(dataEntries: dataEntries2, animated: true)
        
//        }
//        timer.fire()

    }
   

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDayResult"){
        }
    }
    
    func generateEmptyDataEntries() -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<numEntry).forEach {_ in
            result.append(DataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }
    
    func generateRandomDataEntries() -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        let daylist7English = daylist7EnglishReverse()
        for i in 0..<daylist7English.count {
            //グラフの値が入る（タスク評価の値が入る）
            //let value = (arc4random() % 90) + 10
            var value = 0.0
            value = Double(rateAverage[i])
            print("::::::::::::::::::::::::::::::::::::")
            let height: Float = Float(value) / 100.0
            //date.addTimeInterval(TimeInterval(24*60*60*i))
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: daylist7English[i]))
        }
        return result
    }
}

extension DayResultViewController: DayResultDelegate{
    
    func moveCordinate(x1: Int, y1: Int) {
        xx = x1
        print("xxxxxxxxxxx\(x1)")
        print(xx)
        barChart.moveCordinate1(x1: xx!, y1: 0)
    }
}


