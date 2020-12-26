//
//  HomeViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/06/19.
//  Copyright © 2019 古府侑樹. All rights reserved.
//
import UIKit
//import YYBottomSheet
import PullableSheet
import RealmSwift
class HomeViewController: UIViewController {
    //コメント追加
    var todoListArray = [MyTodo]()
    var index :Int = 0
    @IBOutlet weak var menhera: UIImageView!
    let menhera_0 = UIImage(named: "メンヘラ彼女_0")! as UIImage
    let menhera_50 = UIImage(named: "メンヘラ彼女_50")! as UIImage
    let menhera_75 = UIImage(named: "メンヘラ彼女_75")! as UIImage
    let menhera_100 = UIImage(named: "メンヘラ彼女_100")! as UIImage
    // スクリーン画面のサイズを取得
    let scWid: CGFloat = UIScreen.main.bounds.width     //画面の幅
    let scHei: CGFloat = UIScreen.main.bounds.height    //画面の高さ

    @IBOutlet weak var talk: UILabel!
    @IBOutlet weak var menheraMeter: UIProgressView!
    @IBOutlet weak var meterBackground: UIImageView!
    @IBOutlet weak var todoButton: CustomButton!
    @IBOutlet weak var calendarButton: CustomButton!
    @IBOutlet weak var feedbackButton: CustomButton!
    @IBOutlet weak var menheraKanojo: UIImageView!
    @IBOutlet weak var desk: UIImageView!
    @IBOutlet weak var speechZone: UIImageView!
    
    
    let realm = try! Realm()
    var score:Double = 75.0
    var timerMeter:Timer?
    var percent:Int = 50
    var progress:Float = 0.0
    
    
    override func viewDidLoad() { //切り替えても呼び出されない...
        super.viewDidLoad()
        //score = UserDefaults.standard.object(forKey: "score") as! Double //取り出し
        timerMeter = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(HomeViewController.meterUpdate), userInfo: nil, repeats: true)//0.1秒毎にtimerUpdate

        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let results = realm.objects(Calendar24.self).filter("start >= %@ AND start <= %@", Date(), Calendar.current.date(byAdding: .hour, value: 24, to: Date())!).sorted(byKeyPath: "start", ascending: true)
        let task = results.first
        var task_name :String = ""
        var talkcontent :String = ""
        if results.count > 0 {
            task_name = task!.todo.first!.title
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: Date(), to: task!.start)
            if dateComponents.hour == 0 {
                talkcontent = String(dateComponents.minute!) + "分後に\(task_name)のタスクが入っているよ！"
            }else{
                talkcontent = "\(dateComponents.hour!)時間\(dateComponents.minute!)分後に\(task_name)のタスクが入っているよ！"
            }
            talk.adjustsFontSizeToFitWidth = true
            talk.text = talkcontent
        }

        var scala:CGFloat?
        if view.frame.width/375 > view.frame.height/667 {
            scala = view.frame.height/667
        } else {
            scala = view.frame.width/375
        }

        speechZone.frame = CGRect(x: 0, y: view.frame.height*0.11, width: speechZone.frame.width*scala!, height: speechZone.frame.height*scala!)
        talk.frame = CGRect(x: view.frame.width*0.019, y: view.frame.height*0.15, width: talk.frame.width*scala!, height: talk.frame.height*scala!)
        calendarButton.frame = CGRect(x: view.frame.width*0.7, y: view.frame.height*0.14, width: calendarButton.frame.width*scala!, height: calendarButton.frame.height*scala!)
        feedbackButton.frame = CGRect(x: view.frame.width*0.72, y: view.frame.height*0.5, width: feedbackButton.frame.width*scala!, height: feedbackButton.frame.height*scala!)
        todoButton.frame = CGRect(x: view.frame.width*0.0186, y: view.frame.height*0.41, width: todoButton.frame.width*scala!, height: todoButton.frame.height*scala!)
        desk.frame = CGRect(x: 0, y: view.frame.height*0.494, width: desk.frame.width*scala!, height: desk.frame.height*scala!)
        menheraMeter.frame = CGRect(x: view.frame.width/4.3, y: view.frame.height/15, width: menheraMeter.frame.width*scala!, height: menheraMeter.frame.height*scala!)
        menheraMeter.transform = CGAffineTransform(scaleX: 1.0, y: view.frame.height/180)
        menheraMeter.layer.cornerRadius =  10
        menheraMeter.layer.borderColor = UIColor.red.cgColor
        menheraMeter.layer.borderWidth = 0.0003 * view.frame.height
        menheraMeter.layer.masksToBounds = true
        meterBackground.frame = CGRect(x: view.frame.width*0.08, y: view.frame.height*0.043, width: view.frame.width*0.85, height: view.frame.height*0.061)
        
        if score <= 25{
            menhera.image = menhera_100
        }else if score <= 50{
            menhera.image = menhera_75
        }else if score <= 75{
            menhera.image = menhera_50
        }else{
            menhera.image = menhera_0
        }
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
        vc.attach(to: self)
        timerMeter?.invalidate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        loadView()
        viewDidLoad()
    }
    
    @objc func meterUpdate() {
        progress = progress + 0.005
        if progress < Float(self.percent)*0.01 {
            menheraMeter.setProgress(progress, animated: true)
            print(progress)
        } else {
            self.timerMeter?.invalidate()
            print(floor(progress*100)/100) //小数第３位を切り上げ
            print("stop")
        }
    }
    
}


