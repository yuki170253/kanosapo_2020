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
import LineSDK
import CryptoSwift

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
    var barImageView: UIImageView!
    @IBOutlet weak var talk: UILabel!
    @IBOutlet weak var menheraMeter: UIProgressView!
    @IBOutlet weak var meterBackground: UIImageView!
    @IBOutlet weak var todoButton: CustomButton!
    @IBOutlet weak var calendarButton: CustomButton!
    @IBOutlet weak var feedbackButton: CustomButton!
    @IBOutlet weak var menheraKanojo: UIImageView!
    @IBOutlet weak var desk: UIImageView!
    @IBOutlet weak var speechZone: UIImageView!
    
    @IBOutlet weak var background: UIImageView!
    
    let realm = try! Realm()
    var score:Double = 75.0
    var timerMeter:Timer?
    var percent:Int = 50
    var progress:Float = 0.0
    
    
    override func viewDidLoad() { //切り替えても呼び出されない...
        super.viewDidLoad()
        score = UserDefaults.standard.object(forKey: "score") as! Double //取り出し
        percent = Int(score)
        //        print(daylist7Reverse())
        //        timerMeter = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(HomeViewController.meterUpdate), userInfo: nil, repeats: true)//0.1秒毎にtimerUpdate
        background.contentMode = UIView.ContentMode.scaleAspectFill
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        changeMessage()
        
        score = UserDefaults.standard.object(forKey: "score") as! Double
        drawgauge(stop: CGFloat(score))
        let screen = ScreenSize()
        let scala = screen.ratio
        speechZone.frame = CGRect(x: 0, y: view.frame.height*0.11, width: speechZone.frame.width*scala, height: speechZone.frame.height*scala)
        talk.frame = CGRect(x: view.frame.width*0.019, y: view.frame.height*0.15, width: talk.frame.width*scala, height: talk.frame.height*scala)
        calendarButton.frame = CGRect(x: view.frame.width*0.7, y: view.frame.height*0.14, width: calendarButton.frame.width*scala, height: calendarButton.frame.height*scala)
        feedbackButton.frame = CGRect(x: view.frame.width*0.72, y: view.frame.height*0.5, width: feedbackButton.frame.width*scala, height: feedbackButton.frame.height*scala)
        todoButton.frame = CGRect(x: view.frame.width*0.0186, y: view.frame.height*0.41, width: todoButton.frame.width*scala, height: todoButton.frame.height*scala)
        desk.frame = CGRect(x: 0, y: view.frame.height*0.494, width: desk.frame.width*scala, height: desk.frame.height*scala)
        menheraMeter.frame = CGRect(x: view.frame.width/4.3, y: view.frame.height/15, width: menheraMeter.frame.width*scala, height: menheraMeter.frame.height*scala)
        menheraMeter.transform = CGAffineTransform(scaleX: 1.0, y: view.frame.height/180)
        menheraMeter.layer.cornerRadius =  10
        menheraMeter.layer.borderColor = UIColor.red.cgColor
        menheraMeter.layer.borderWidth = 0.0003 * view.frame.height
        menheraMeter.layer.masksToBounds = true
        meterBackground.frame = CGRect(x: view.frame.width*0.015, y: view.frame.height*0.043, width: view.frame.width*0.85, height: view.frame.height*0.061)
        
        let meterWhite = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 12))
        let meterPink = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 12))
        meterWhite.center = CGPoint(x: meterBackground.frame.size.width/2 , y: meterBackground.frame.size.height/2 - 3 * scala)
        meterWhite.backgroundColor = UIColor.white
        meterWhite.layer.cornerRadius =  10
        meterBackground.addSubview(meterWhite)
        meterPink.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        meterPink.layer.cornerRadius =  10
        meterPink.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        meterWhite.addSubview(meterPink)
        menheraMeter.removeFromSuperview()
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseInOut , animations: {
            meterPink.frame.size.width = meterWhite.frame.size.width / 100 * CGFloat(self.percent)
        }, completion: nil)
        
        //修正　by牧内　12/26
        if score < 25{
            menhera.image = menhera_100
        }else if score < 50{
            menhera.image = menhera_75
        }else if score < 75{
            menhera.image = menhera_50
        }else{
            menhera.image = menhera_0
        }
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
        vc.attach(to: self)
        
        
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //let realm = try! Realm()
        //        try! realm.write {
        //            print("addされました。")
        //            let todo = Todo()
        //            let todo2 = Todo()
        //            todo.title = "テストデータ"
        //            todo2.title = "勉強"
        //            todo.date = Date()
        //            todo2.date = Date() + 1
        //            let calendar1 = Calendar24()
        //            let calendar2 = Calendar24()
        //            // UserとCommunityに対して
        //            // １対多の関連を作るには、次のようにして、
        //            // List<Community>のプロパティにcommunityオブジェクトを
        //            // 追加します。
        //            todo.calendars.append(calendar1)
        //            todo.calendars.append(calendar2)
        //            realm.add(todo)
        //            realm.add(todo2)
        //        }
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        loadView()
        viewDidLoad()
    }
    @IBAction func restart(_ segue: UIStoryboardSegue){
        print(segue)
    }
    
    @IBAction func pushed_Girl2Button(_ sender: Any) {
        changeMessage()
    }
    @IBAction func pushed_GirlButton(_ sender: Any) {
        changeMessage()
    }
    
    
    func changeMessage(){
        let Messages50 = ["会いに来てくれてありがとう！",
                        "今日は何する？"]
        let Messages25 = ["もっと会いに来てくれないと寂しいよ...",
                          "やるべきことは早めに取り組まないとだよ？"]
        let Messages0 = ["ちゃんとやってるの最近あんまり見ないな、、、どうして？",
                         "わたし、だらしない人は嫌いかも"]
        
        var body = ""
        if score < 25{
            let index = Int.random(in: 0..<Messages0.count + 2)
            if index >= Messages0.count {
                if index == Messages0.count {
                    talk.text = String(setTaskMessage().dropLast(1))
                }else if index == Messages0.count + 1 {
                    let lineMessage = NSMutableAttributedString(string: "なんでLINEしてくれないの？")
                    lineMessage.addAttribute(.foregroundColor, value: UIColor.green, range: NSMakeRange(3, 4))
                    talk.attributedText = lineMessage
                }
            }else{
                talk.text = Messages0[index]
            }
        }else if score < 50{
            let index = Int.random(in: 0..<Messages25.count + 2)
            if index >= Messages25.count {
                if index == Messages25.count {
                    talk.text = String(setTaskMessage().dropLast(1))
                }else if index == Messages25.count + 1 {
                    let lineMessage = NSMutableAttributedString(string: "たまにはLINEしてよね")
                    lineMessage.addAttribute(.foregroundColor, value: UIColor.green, range: NSMakeRange(4, 4))
                    talk.attributedText = lineMessage
                }
            }else{
                talk.text = Messages25[index]
            }
        }else{
            let index = Int.random(in: 0..<Messages50.count + 2)
            if index >= Messages50.count {
                if index == Messages50.count {
                    talk.text = setTaskMessage()
                }else if index == Messages50.count + 1 {
                    let lineMessage = NSMutableAttributedString(string: "LINEしよ！")
                    lineMessage.addAttribute(.foregroundColor, value: UIColor.green, range: NSMakeRange(0, 4))
                    talk.attributedText = lineMessage
                }
            }else{
                talk.text = Messages50[index]
            }
        }
        talk.adjustsFontSizeToFitWidth = true
    }
    
    func setTaskMessage() -> String {
        let results = realm.objects(Calendar24.self).filter("start >= %@ AND start <= %@", Date(), Calendar.current.date(byAdding: .hour, value: 24, to: Date())!).sorted(byKeyPath: "start", ascending: true)
        let task = results.first
        var task_name :String = ""
        var talkcontent :String = "今のところ24時間以内のタスクはないよ！"
        if results.count > 0 {
            task_name = task!.todo.first!.title
            if task!.todo.first?.todoDone == false {
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: Date(), to: task!.start)
                if dateComponents.hour == 0 {
                    talkcontent = String(dateComponents.minute!) + "分後に\(task_name)のタスクが入っているよ！"
                }else{
                    talkcontent = "\(dateComponents.hour!)時間\(dateComponents.minute!)分後に\(task_name)のタスクが入っているよ！"
                }
            talk.adjustsFontSizeToFitWidth = true
            talk.text = talkcontent
            }
            
            
//            talk.text = talkcontent
        }
        return talkcontent
    }
    
    func drawgauge(stop:CGFloat){
        let rectangleLayer = CAShapeLayer.init()
        let rectangleFrame = CGRect.init(x: scWid*0+90, y: scHei*0+34, width:  scWid*0.52, height: scHei*0.022)
        rectangleLayer.frame = rectangleFrame
        
        // 輪郭の色
        rectangleLayer.strokeColor = UIColor(red:216, green:99, blue:143, alpha: 1.0).cgColor
        // 四角形の中の色
        rectangleLayer.fillColor = UIColor(red:216/255, green:99/255, blue:143/255, alpha: 1.0).cgColor
        // 輪郭の太さ
        rectangleLayer.lineWidth = 0
        // 四角形を描
        rectangleLayer.path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: rectangleFrame.size.width, height: rectangleFrame.size.height)).cgPath
        
        self.view.layer.addSublayer(rectangleLayer)
        
        // 制限時間バーの高さ・幅
        let barHeight = scHei*0.022
        let barWidth = scWid*0.52
        
        // 制限時間バーのX座標・Y座標・終端のX座標
        let barXPosition = scWid*0 + 90
        let barYPosition = scHei*0 + 34
        let barXPositionEnd = barXPosition + barWidth
        
        // UIImageViewを初期化
        barImageView = UIImageView()
        // 画像の表示する座標を指定する
        barImageView.frame = CGRect(x: barXPosition ,y: barYPosition ,width: barWidth ,height: barHeight)
        
        // バーに色を付ける
        barImageView.backgroundColor = UIColor(red:255/255, green:233/255, blue:234/255, alpha: 1.0)
        
        // barImageViewをViewに追加する
        self.view.addSubview(barImageView)
        self.barImageView.layer.borderWidth = 0.1;
        self.barImageView.layer.borderColor = UIColor(red:216, green:99, blue:143, alpha: 1.0).cgColor
        //UIColor(red:255, green:233, blue:234, alpha: 1.0).cgColor
        // バーをアニメーションさせる
        // 10秒かけてバーを左側から等速で減少させる
        UIView.animate(withDuration: 2, delay: 0.0, options:
                        UIView.AnimationOptions.curveEaseIn, animations: {() -> Void  in
                            // アニメーション終了後の座標とサイズを指定
                            self.barImageView.frame = CGRect(x: barXPositionEnd-barWidth/(100/(100-stop)), y: barYPosition, width: barWidth/(100/(100-stop)), height: barHeight)
                        },
                       completion: {(finished: Bool) -> Void in
                        
                       })
    }
    @IBAction func reset_button(_ sender: Any) {

        print("リセットされました。")
    }
    @IBAction func didTapLogin(_ sender: Any) {
        guard let url = URL(string: "https://line.me/R/ti/p/@718ysyiu") else {
            return
        }
        API.Auth.verifyAccessToken { result in
            switch result {
            case .success: //連携済み
                UIApplication.shared.open(url, options: [:], completionHandler: { (succes) in
                    
                })
            case .failure(let error): //未連携
                authentication(vc: self)
                print(error)
            }
        }
        
        
        
    }
    
    
    
    //    @objc func meterUpdate() {
    //        progress = progress + 0.005
    //        if progress < Float(self.percent)*0.01 {
    //            menheraMeter.setProgress(progress, animated: true)
    //            print(progress)
    //        } else {
    //            self.timerMeter?.invalidate()
    //            print(floor(progress*100)/100) //小数第３位を切り上げ
    //            print("stop")
    //        }
    //    }
}


