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

class EvaluViewController: UIViewController, UIApplicationDelegate, UINavigationControllerDelegate  {
    var animationTimer: Timer?
    var countNum = 0 //経過時間
    var donetime = 0 //総合の時間
    var dotime = 0 //目標時間
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
    @IBOutlet weak var dialogueTextLabel: UILabel!
    @IBOutlet weak var titleBaackground: UIView!
    @IBOutlet weak var DialogueBackground: UIView!
    @IBOutlet weak var menheraLabelBackground: UIView!
    @IBOutlet weak var menheraLabel: UILabel!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var objectiveLable: UILabel!
    @IBOutlet weak var LineView: UIView!
    var vc: EvaluViewController2?
    let userDefaults = UserDefaults.standard
    let image_play:UIImage = UIImage(named:"icons8-再生ボタン")!
    let image_stop:UIImage = UIImage(named:"icons8-停止ボタン")!
    var backText: String?
    let realm = try! Realm()
    let texts: [String] = ["「タスク中に遊びに行ってはダメって言ったよね......」", "b", "c", "d"]
    let dialog: UIAlertController = UIAlertController(title: "経過を保存しました", message: "ストップウォッチを停止ました", preferredStyle: .alert)
    override func viewDidLoad() {
        super.viewDidLoad()
        var scala:CGFloat?
        if view.frame.width/375 > view.frame.height/667 {
            scala = view.frame.height/667
        } else {
            scala = view.frame.width/375
        }
        vc = storyboard?.instantiateViewController(withIdentifier: "popupmenu") as? EvaluViewController2
        button.layer.cornerRadius = 50.0

        timeDisplay.frame = CGRect(x: view.frame.width*0.04, y: view.frame.height*0.4, width: view.frame.height*0.514, height: view.frame.height*0.03)
        replay_button.frame = CGRect(x: view.frame.width*0.1, y: view.frame.height*0.6, width: view.frame.height*0.11, height: view.frame.height*0.11)
        button.frame = CGRect(x: view.frame.width*0.365, y: view.frame.height*0.496, width: view.frame.height*0.15, height: 0.15)
        LineView.frame = CGRect(x: view.frame.width*0.1, y: view.frame.height*0.38, width: view.frame.height*0.455, height: 1)
        dotimeDisply.frame = CGRect(x: view.frame.width*0.12, y: view.frame.height*0.307, width: view.frame.height*0.413, height: view.frame.height*0.073)
        save_button.frame = CGRect(x: view.frame.width*0.69, y: view.frame.height*0.617, width: view.frame.height*0.105, height: view.frame.height*0.105)
        titleBaackground.frame = CGRect(x: view.frame.width*0.042, y: view.frame.height*0.115, width: view.frame.height*0.514, height: view.frame.height*0.18)
        objectiveLable.frame = CGRect(x: view.frame.width*0.085, y: view.frame.height*0.118, width: view.frame.height*0.135, height: view.frame.height*0.04)
        testlabel.frame = CGRect(x: 0, y: 0, width: view.frame.height*0.514, height: view.frame.height*0.1)
        target_time_label.frame = CGRect(x: view.frame.width*0.44, y: view.frame.height*0.113, width: view.frame.height*0.156, height: view.frame.height*0.051)
        DialogueBackground.frame = CGRect(x: view.frame.width*0.042, y: view.frame.height*0.82, width: view.frame.height*0.514, height: view.frame.height*0.1)
        dialogueTextLabel.frame = CGRect(x: view.frame.width*0.024, y: view.frame.height*0.03, width: view.frame.height*0.505, height: view.frame.height*0.066)
        menheraLabelBackground.frame = CGRect(x: view.frame.width*0.04, y: view.frame.height*0.81, width: view.frame.height*0.171, height: view.frame.height*0.039)
        menheraLabel.frame = CGRect(x: view.frame.width*0.058, y: view.frame.height*0.0059, width: view.frame.height*0.126, height: view.frame.height*0.025)
        playImage.frame = CGRect(x: view.frame.width*0.0026, y: view.frame.height*0.0059, width: view.frame.height*0.03, height: view.frame.height*0.025)
        
        // 登録
        NotificationCenter.default.addObserver(self, selector: #selector(EnterForeground(
            notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EnterBackground(
        notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        print("viewWillappear")
        let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
        id = result!.title
        donetime = result!.donetime
        dotime = result!.dotime
        store_donetime = donetime
        let s = donetime % 60
        let m = (donetime / 60) % 60
        let h = (donetime / 3600)
        testlabel.text = result!.title
        dotimeDisply.text = String(format: "%02d:%02d:%02d",  h, m, s)
        target_time_label.text = String(format: "%02d:%02d:%02d", (result!.dotime / 3600), (result!.dotime / 60) % 60, result!.dotime % 60)
        if (dotime - donetime) <= 0 {
            timeDisplay.text = "目標時間に達しました。"
        }else{
            timeDisplay.text = String(format: "目標時間達成まであと %02d:%02d:%02d", (dotime - donetime) / 3600 , ((dotime - donetime) / 60) % 60, (dotime - donetime) % 60)
        }
        
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
        if timerRunning{
            end = Date()
            let diff = end.timeIntervalSince(start)
            countNum += Int(diff)
            donetime += Int(diff)
            print(donetime)
            let randn = Int.random(in: 0 ... texts.count-1)
            dialogueTextLabel.text = texts[randn]
        }
    }
    
    // AppDelegate -> applicationDidEnterBackgroundの通知
    @objc func EnterBackground(notification: Notification) {
        if timerRunning{
            start = Date()
        }
        let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
        
        if timerRunning == true {
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
        if (dotime - donetime - countNum) <= 0 {
            timeDisplay.text = "目標時間に達しました。"
        }else {
            timeDisplay.text = String(format: "目標時間達成まであと %02d:%02d:%02d", (dotime - donetime - countNum) / 3600 , ((dotime - donetime - countNum) / 60) % 60, (dotime - donetime - countNum) % 60)
        }
        //timeDisplay.text = String(format: "目標時間達成まであと %02d:%02d:%02d", h,m,s)
        dotimeDisply.text = String(format: "%02d:%02d:%02d", (donetime + countNum) / 3600, ((donetime + countNum) / 60) % 60, (donetime + countNum) % 60)
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
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EvaluViewController.updateDisplay), userInfo: nil, repeats: true)
            timerRunning = true
            sender.setImage(image_stop, for: .normal)
        }else{
            timer.invalidate()
            timerRunning = false
            sender.setImage(image_play, for: .normal)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
            try! realm.write {
                donetime = result!.donetime
                donetime += countNum
                result!.donetime = donetime
                countNum = 0
                //result!.selfEvaluation = 3.0
            }
            self.present(dialog, animated: true, completion: {
                // アラートを閉じる
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.dialog.dismiss(animated: true, completion: nil)
                })
            })
            
            """
            let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
            timeDisplay.text = String(format: "目標時間達成まで %02d:%02d:%02d", 0 ,0 , 0)
            try! realm.write {
                var donetime:Int = result!.donetime
                donetime += countNum
                result!.donetime = donetime
                result!.selfEvaluation = 3.0
            }
            countNum = 0
            """
        }
    }
    
    @IBAction func Reset(_ sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: "リセット", message: "本当に最初から始めますか？", preferredStyle:  UIAlertController.Style.alert)
    
        if timerRunning {
            timer.invalidate()
            timerRunning = false
            button.setImage(self.image_play, for: .normal)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
            try! realm.write {
                donetime = result!.donetime
                donetime += countNum
                result!.donetime = donetime
                countNum = 0
            }
            self.present(dialog, animated: true, completion: {
                // アラートを閉じる
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.dialog.dismiss(animated: true, completion: nil)
                })
            })
        }

        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
            self.resetMethod()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func TaskSaveButton(_ sender: Any) {
        print("save")
        if timerRunning {
            timer.invalidate()
            timerRunning = false
            button.setImage(image_play, for: .normal)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
            try! realm.write {
                donetime = result!.donetime
                donetime += countNum
                result!.donetime = donetime
                countNum = 0
            }
            self.present(dialog, animated: true, completion: {
                // アラートを閉じる
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.dialog.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    @IBAction func backButtonAction(_ sender: Any) {
        print("backボタンのアクション")
        if timerRunning{
            timer.invalidate()
            timerRunning = false
            button.setImage(image_play, for: .normal)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
            try! realm.write {
                donetime = result!.donetime
                donetime += countNum
                result!.donetime = donetime
                countNum = 0
            }
            self.present(dialog, animated: true, completion: {
                // アラートを閉じる
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.dialog.dismiss(animated: true, completion: nil)
                })
            })
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func resetMethod(){
        countNum = 0
        let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
        try! self.realm.write {
            result!.donetime = 0
            donetime = 0
        }
        timeDisplay.text = String(format: "目標時間達成まであと %02d:%02d:%02d", (dotime - donetime) / 3600 , ((dotime - donetime) / 60) % 60, (dotime - donetime) % 60)
        dotimeDisply.text = String(format: "%02d:%02d:%02d", (donetime / 3600), (donetime / 60) % 60, donetime % 60)
    }
}
