//
//  EvaluViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/06/19.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class EvaluViewController: UIViewController, UIApplicationDelegate  {
    var animationTimer: Timer?
    var countNum = 0
    var donetime = 0
    var store_donetime = 0
    var timerRunning = false
    var timer = Timer()
    var myTodo = MyTodo()
    var todoListArray = [MyTodo]()

    var start :Date = Date()
    var end :Date = Date()
    var id :String = ""
    var todoid :String = ""
    var usedCount = 0
    @IBOutlet weak var testlabel: UILabel!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var dotimeDisply: UILabel!
    @IBOutlet weak var target_time_label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var replay_button: UIButton!
    @IBOutlet weak var save_button: UIButton!
    
    var vc: EvaluViewController2?
    let userDefaults = UserDefaults.standard
    let image_play:UIImage = UIImage(named:"icons8-再生ボタン")!
    let image_stop:UIImage = UIImage(named:"icons8-停止ボタン")!
    var backText: String?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc = storyboard?.instantiateViewController(withIdentifier: "popupmenu") as? EvaluViewController2
        button.layer.cornerRadius = 50.0
        // 登録
        NotificationCenter.default.addObserver(self, selector: #selector(EnterForeground(
            notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EnterBackground(
            notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        print("viewWillappear")
        let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
        id = result!.title
        donetime = result!.donetime
        store_donetime = donetime
        let s = donetime % 60
        let m = (donetime / 60) % 60
        let h = (donetime / 3600)
        testlabel.text = result!.title
        dotimeDisply.text = String(format: "%02d:%02d:%02d",  h, m, s)
        target_time_label.text = String(format: "%02d:%02d:%02d", (result!.dotime / 3600), (result!.dotime / 60) % 60, result!.dotime % 60)
        
        //スマホのロック状態の把握
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(changedAppStatus(_:)),
                         name: UIApplication.protectedDataDidBecomeAvailableNotification,
                         object: nil)

        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(changedAppStatus(_:)),
                         name: UIApplication.protectedDataWillBecomeUnavailableNotification,
                         object: nil)
    }
    
    //スマホのロック状態に対応した処理
    @objc func changedAppStatus(_ notification: Notification) {
        if notification.name == UIApplication.protectedDataDidBecomeAvailableNotification {
            print("unlocked")
            // unlocked device
        }
        if notification.name == UIApplication.protectedDataWillBecomeUnavailableNotification {
            // locked device
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["outside"])
            usedCount = usedCount - 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    func trans(){
        performSegue(withIdentifier: "toResultViewController", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timerRunning = false
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["outside"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    // AppDelegate -> applicationWillEnterForegroundの通知
    @objc func EnterForeground(notification: Notification) { //ここのメソッドが２回はしる
        print("フォアグラウンド")
        if timerRunning{
            end = Date()
            let diff = end.timeIntervalSince(start)
            print("diff")
            print(diff)
            countNum += Int(diff/2)
            donetime += Int(diff/2)
            print(end)
        }
    }
    
    // AppDelegate -> applicationDidEnterBackgroundの通知
    @objc func EnterBackground(notification: Notification) {
        print("バックグラウンド")
        if timerRunning{
            start = Date()
            print(start)
        }
        let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
        
        if timerRunning == true {
            //かける追加 12/10 if(result!.dotime! <= countNum){}で囲う
            if(result!.dotime >= countNum){
                print("中")
                //目標時間経過時の通知
                let target = UNMutableNotificationContent()
                target.title = testlabel.text! //通知のタイトル
                target.body = "目標時間になりました！" //通知の本文
                var sumTime = result!.dotime - result!.donetime - countNum
                if sumTime < 0 {
                    sumTime = 1
                }
                target.sound = UNNotificationSound.default //通知の音
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(sumTime), repeats: false)
                let request = UNNotificationRequest(identifier: id, content: target,
                                                    trigger: trigger) //通知のリクエスト
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil) //通知を実装
                
            }
            //アプリから離れた際の通知
            let outside = UNMutableNotificationContent()
            //outside.title = testlabel.text!
            outside.body = "アプリに戻って！"
            outside.sound = UNNotificationSound.default
            let outsideTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let outsideRequest = UNNotificationRequest(identifier: "outside", content: outside, trigger: outsideTrigger)
            UNUserNotificationCenter.current().add(outsideRequest, withCompletionHandler: nil)
            usedCount = usedCount + 1
        }
    }
    
    
    
    @objc func updateDisplay(){
        countNum += 1
        donetime += 1
        let s = countNum % 60
        let m = (countNum / 60) % 60
        let h = (countNum / 3600)
        //let ms = countNum % 100
        //let s = (countNum - ms) / 100 % 60
        //let m = (countNum - s - ms) / 6000 % 3600
        timeDisplay.text = String(format: "++ %02d:%02d:%02d", h,m,s)
        dotimeDisply.text = String(format: "%02d:%02d:%02d", (donetime / 3600), (donetime / 60) % 60, donetime % 60)
    }
    
    
    @IBAction func StartStop(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 8,
                       options: .curveEaseOut,
                       animations: { () -> Void in
                                self.button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) }, completion: nil)
        if timerRunning == false {
            NotificationCenter.default.addObserver(self, selector: #selector(EnterForeground(
                notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EvaluViewController.updateDisplay), userInfo: nil, repeats: true)
            timerRunning = true
            sender.setImage(image_stop, for: .normal)
        }else{
            timer.invalidate()
            timerRunning = false
            sender.setImage(image_play, for: .normal)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
            timeDisplay.text = String(format: "++ %02d:%02d:%02d", 0 ,0 , 0)
            try! realm.write {
                var donetime:Int = result!.donetime
                donetime += countNum
                result!.donetime = donetime
                result!.selfEvaluation = 3.0
            }
            countNum = 0
        }
    }
    
    @IBAction func Reset(_ sender: UIButton) {
        countNum = 0
        donetime = store_donetime
        timeDisplay.text = "++ 00:00.00"
        dotimeDisply.text = String(format: "%02d:%02d:%02d", (donetime / 3600), (donetime / 60) % 60, donetime % 60)
    }
    
    @IBAction func TaskSaveButton(_ sender: Any) {
        //performSegue(withIdentifier: "EvaluDetails", sender: nil)
        //performSegue(withIdentifier: "toEvalu2", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         /*
         let evaludetailsviewcontroller = segue.destination as! EvaluDetailsViewController
         evaludetailsviewcontroller.sepatime = countNum
         evaludetailsviewcontroller.index = index
         */
        
        if (segue.identifier == "toResultViewController") {
            let vc = segue.destination as! ResultViewController
            vc.toDoId = todoid
        }else if(segue.identifier == "toEvalu2") {
            let vc = segue.destination as! EvaluViewController2
            vc.todoid = todoid
            vc.countNum = countNum
            vc.usedCount = usedCount
        }
    }
}
