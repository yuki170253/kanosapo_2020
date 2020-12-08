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
    let realm = try! Realm()
    var score:Double = 50.0
    override func viewDidLoad() { //切り替えても呼び出されない...
        super.viewDidLoad()
        score = UserDefaults.standard.object(forKey: "score") as! Double //取り出し
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
        
        score = UserDefaults.standard.object(forKey: "score") as! Double
        drawgauge(stop: CGFloat(score))
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
}


