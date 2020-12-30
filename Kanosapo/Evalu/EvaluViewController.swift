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
    
   
    
    
    func autoLayout(){
        print("center",view.center)
        let screen = ScreenSize()
        let ratio = ScreenSize().ratio
        let screenDif = screen.screenHeight - 667.0
        // ステータスバーの高さを取得する
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        // ナビゲーションバーの高さを取得する
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
        if screen.screenHeight > 926 {
            titleBaackground.frame = CGRect(x: 0, y: statusBarHeight + navigationBarHeight! + 30 * ratio, width: titleBaackground.frame.size.width * ratio, height: titleBaackground.frame.size.height * ratio)
        }else {
            titleBaackground.frame = CGRect(x: 0, y: statusBarHeight + navigationBarHeight! + 30 * ratio + screenDif/2, width: titleBaackground.frame.size.width * ratio, height: titleBaackground.frame.size.height * ratio)
        }
        titleBaackground.center.x = view.center.x
        objectiveLable.frame = CGRect(x: titleBaackground.frame.size.width/4, y: objectiveLable.frame.origin.y * ratio, width: objectiveLable.frame.size.width * ratio, height: objectiveLable.frame.size.height * ratio)
        objectiveLable.center.x = titleBaackground.frame.size.width/4
        testlabel.frame = CGRect(x: 0, y: 0, width: testlabel.frame.size.width * ratio, height: testlabel.frame.size.height * ratio)
        target_time_label.frame = CGRect(x: target_time_label.frame.origin.x * ratio, y: target_time_label.frame.origin.y * ratio, width: target_time_label.frame.size.width * ratio, height: target_time_label.frame.size.height * ratio)
        target_time_label.center.x = titleBaackground.frame.size.width/4 * 3
        dotimeDisply.frame = CGRect(x: 0, y: titleBaackground.frame.maxY + 10 * ratio , width: dotimeDisply.frame.size.width * ratio, height: dotimeDisply.frame.size.height * ratio)
        dotimeDisply.center.x = view.center.x
        LineView.frame = CGRect(x: 0, y: dotimeDisply.frame.maxY, width: LineView.frame.size.width * ratio , height: 1)
        LineView.center.x = view.center.x
        timeDisplay.frame = CGRect(x: 0, y: LineView.frame.maxY + 5 * ratio, width: timeDisplay.frame.size.width * ratio, height: timeDisplay.frame.size.height * ratio)
        timeDisplay.center.x = view.center.x
        button.frame = CGRect(x: 0, y: timeDisplay.frame.maxY + 30 * ratio, width: button.frame.size.width * ratio, height: button.frame.size.height * ratio)
        button.center.x = view.center.x
        
        replay_button.frame = CGRect(x: LineView.frame.minX, y: button.frame.maxY + 2 * ratio, width: replay_button.frame.size.width * ratio, height: replay_button.frame.size.height * ratio)
        replay_button.center.x = LineView.frame.minX
        save_button.frame = CGRect(x: LineView.frame.maxX, y: button.frame.maxY + 2 * ratio, width: save_button.frame.size.width * ratio, height: save_button.frame.size.height * ratio)
        save_button.center.x = LineView.frame.maxX
        DialogueBackground.frame = CGRect(x: 0, y: save_button.frame.maxY + 30 * ratio, width: DialogueBackground.frame.size.width * ratio, height: DialogueBackground.frame.size.height * ratio)
        DialogueBackground.center.x = view.center.x
        dialogueTextLabel.frame = CGRect(x: 0, y: 0, width: dialogueTextLabel.frame.size.width * ratio, height: dialogueTextLabel.frame.size.height * ratio)
        dialogueTextLabel.center.x = view.center.x
        dialogueTextLabel.center.y = DialogueBackground.frame.size.height/2
        menheraLabelBackground.frame = CGRect(x: DialogueBackground.frame.origin.x, y: 0, width: menheraLabelBackground.frame.size.width * ratio, height: menheraLabelBackground.frame.size.height * ratio)
        menheraLabelBackground.center.y = DialogueBackground.frame.origin.y
        menheraLabel.frame = CGRect(x: menheraLabel.frame.origin.x * ratio, y: 0, width: menheraLabel.frame.size.width * ratio, height: menheraLabel.frame.size.height * ratio)
        menheraLabel.center.y = menheraLabelBackground.frame.size.height / 2
        playImage.frame = CGRect(x: playImage.frame.origin.x * ratio, y: 0, width: playImage.frame.size.width * ratio, height: playImage.frame.size.height * ratio)
        playImage.center.y = menheraLabelBackground.frame.size.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var scala:CGFloat?
        if view.frame.width/375 > view.frame.height/667 {
            scala = view.frame.height/667
        } else {
            scala = view.frame.width/375
        }
        autoLayout()
        vc = storyboard?.instantiateViewController(withIdentifier: "popupmenu") as? EvaluViewController2
        button.layer.cornerRadius = 50.0
        //登録
//        NotificationCenter.default.addObserver(self, selector: #selector(EnterForeground), name: .stopwatch, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EnterForeground(
                                                notification:)), name: .stopwatch, object: nil)
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
//            donetime += Int(diff)
            let randn = Int.random(in: 0 ... texts.count-1)
            dialogueTextLabel.text = texts[randn]
            print("diff\(diff)")
            print("countNum:\(countNum)")
            
        }
    }
    
    // AppDelegate -> applicationDidEnterBackgroundの通知
    @objc func EnterBackground(notification: Notification) {
        if timerRunning{
            start = Date()
        }
        let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
        let score = UserDefaults.standard.object(forKey: "score") as! Double
        
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
            let happyMessage = ["それは急用なの？",
                                "わたしと一緒にがんばろう？",
                                "集中して取り組む姿をわたしに見せて！"]
            let menheraMessage = ["集中して取り組まないとおこだぞ！！",
                                  "わたしと一緒じゃがんばれないって言うの...？"]
            var body = "アプリに戻って！"
            
            if usedCount > 0 { //アプリを離れて２度目以降
                if score < 25{
                    let index = Int.random(in: 0..<menheraMessage.count)
                    body = menheraMessage[index]
                }else if score < 50{
                    let index = Int.random(in: 0..<menheraMessage.count)
                    body = menheraMessage[index]
                }else if score < 75{
                    let index = Int.random(in: 0..<happyMessage.count)
                    body = happyMessage[index]
                }else{
                    let index = Int.random(in: 0..<happyMessage.count)
                    body = happyMessage[index]
                }
            }
            
            outside.body = body
            outside.sound = UNNotificationSound.default
            let outsideTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.2, repeats: false)
            let outsideRequest = UNNotificationRequest(identifier: "outside", content: outside, trigger: outsideTrigger)
            UNUserNotificationCenter.current().add(outsideRequest, withCompletionHandler: nil)
            usedCount = usedCount + 1
            try! realm.write { //ここにメンヘラメーターを変化させるような式を記述
                result!.usedCount += 1
            }
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
//            NotificationCenter.default.addObserver(self, selector: #selector(EnterForeground(
//                notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
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
