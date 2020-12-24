//
//  ViewController.swift
//  test2
//
//  Created by 三浦翔 on 2019/09/28.
//  Copyright © 2019 Swift-Biginners. All rights reserved.
//

import UIKit
import Foundation

import EventKit
import RealmSwift


class ViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var dummyAll: NSLayoutConstraint!
    @IBOutlet weak var AllScrollView: UIScrollView!
    @IBOutlet weak var day: UINavigationItem!
    @IBOutlet weak var AnimationView: UIView!
    @IBOutlet weak var MyScrollView: UIScrollView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var NewMenuView: UIView!
    @IBOutlet weak var MenuScrollView: UIScrollView!
    var MenuFlag = false
    @IBOutlet weak var AlldayView: UIView!
    
    var startTransform:CGAffineTransform!
    var large = false
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func EnlargeScreen(_ sender: UITapGestureRecognizer) {
        print(sender.location(in: self.view))
        if (sender.state == UIGestureRecognizer.State.ended) {
            
            var currentTransform = ContentView.transform
            var doubleTapStartCenter = ContentView.center
            
            var transform: CGAffineTransform! = nil
            var scale: CGFloat = 1.5 // ダブルタップでは現在のスケールの2倍にする
            
            
            // 現在の拡大率を取得する
            let currentScale = sqrt(abs(ContentView.transform.a * ContentView.transform.d - ContentView.transform.b * ContentView.transform.c))
            let tapPoint = sender.location(in: self.view)
            
            var newCenter: CGPoint = CGPoint(
                x: self.view.frame.size.width / 2,
                y: doubleTapStartCenter.y - ((tapPoint.y - doubleTapStartCenter.y) * scale - (tapPoint.y - doubleTapStartCenter.y)))
            
            // 拡大済みのサイズがmaxScaleを超えていた場合は、初期サイズに戻す
            //if (MyScrollView.zoomScale > MyScrollView.maximumZoomScale) {
            if(large == true){
                scale = 1
                
                transform = .identity
                newCenter.y = self.view.frame.size.height / 2 + MyScrollView.contentOffset.y
                doubleTapStartCenter.y = newCenter.y
                
                large = false
            } else {
                transform = currentTransform.concatenating(CGAffineTransform(scaleX: 1, y: scale))
                
                newCenter.y = doubleTapStartCenter.y - ((tapPoint.y - doubleTapStartCenter.y) * scale - (tapPoint.y - doubleTapStartCenter.y)) - MyScrollView.contentOffset.y/2
                
                large = true
            }
            
            // ズーム（イン/アウト）と中心点の移動
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                if(self.large == false){
                    //self.MyScrollView.contentSize.height = 1720
                    //                    self.ContentView.frame.size.height /= scale
                    self.ContentView.center.y = CGFloat(840)
                    
                }else {
                    self.ContentView.center = newCenter
                    //self.MyScrollView.contentSize.height = self.MyScrollView.contentSize.height * scale
                    //                    self.ContentView.frame.size.height *= scale
                    
                }
                self.ContentView.transform = transform
                
            }, completion: {(finished: Bool) -> Void in
            })
        }
    }
    
    
    
    @IBAction func calshow(_ sender: Any) {
        print("calshow")
        if(menuContentView.subviews.count > 1){
            MenuFlag = MenuOC(menu: NewMenuView, scroll: MenuScrollView, flag: MenuFlag)
        }else {
            // アラート作成
            let alert = UIAlertController(title: "タスクがありません", message: "タスクを追加してください", preferredStyle: .alert)
            // アラート表示
            self.present(alert, animated: true, completion: {
                // アラートを閉じる
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    alert.dismiss(animated: true, completion: nil)
                })
            })
        }
        
    }
    
    @objc func EnterForeground(notification: Notification?) { //ここのメソッドが２回はしる
        if(self.isViewLoaded && (self.view.window != nil)){
            print("フォアグラウンド")
            MyScrollView.contentOffset.y = 0
            
            try! realm.write{
                let results = realm.objects(DefaultCalendar.self)
                realm.delete(results)
            }
            Initialization()
        }
        
    }
    
    var menuPos = CGPoint(x: 0, y: 0)
    
    var location = CGPoint(x: 0, y: 0)
    var aTouch = UITouch()
    var sTouch = CGPoint(x: 0, y: 0)
    
    var userY = CGFloat()
    //    var flag = Int()  // 0: Manu  1:Allday
    var currentPoint: CGPoint!
    var TestView = UIView()
    var isRefreshing = false
    var animeFlag = Int()
    var ActivityIndicator: UIActivityIndicatorView!
    var autoScrollTimer = Timer()
    var dummyAllFlag = false
    let topBorder = CALayer()
    var todo = Todo()
    var cal = Calendar24()
    let realm = try! Realm()
    let eventStore = EKEventStore()
    var taskBorder = [CGFloat]()
    
    var centerPoint = CGPoint()
    var scrollFlag = false
    var moveView1 = CGPoint()
    var moveView2 = CGPoint()
    
    var leftFlag = false
    
    var menuContentView = UIView()
    var allContentView = UIView()
    //scrollViewDidEndで使ってる？
    var NOW = NSDate()
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).calendarFlag = true
        //        //削除予定
        //        dummyManu.constant = 0
        //        dummyAll.constant = 50
        //        dummyTarget.constant = 0
        //        topBorder.frame = CGRect(x: 0, y: 0, width: 125, height: 1.0)
        //        topBorder.backgroundColor = UIColor.black.cgColor
        //        TargetView.layer.addSublayer(topBorder)
        //        //
        
        scrollViewFrame()
        NOW = NSDate()
        ContentView.clipsToBounds = true
        setLabel()
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: (AnimationView.frame.width / 2) - 25, y: 20, width: 50, height: 50)
        ActivityIndicator.color = UIColor.darkGray
        ActivityIndicator.hidesWhenStopped = true
        self.AnimationView.addSubview(ActivityIndicator)
        Initialization()
        
        
        //UIGestureのインスタンス
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        //UIGestureのデリゲート
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        MenuScrollView.delegate = self
        
        print("kkkkkkkkkkkk")
        print(MenuScrollView.subviews[2].subviews)
        for item in MenuScrollView.subviews{
            print("-----")
            print(item)
        }
    }
    //deleteボタンの生成
    func makeButton() -> UIButton{
        print("makeButton")
        let button :UIButton = UIButton(frame: CGRect(x: 285,y: 0,width: 15,height: 15))
        button.setImage(UIImage(named:"close_black"), for: .normal)
        button.addTarget(self, action: #selector(deleteView(_:)), for: UIControl.Event.touchUpInside)
        return button
    }
    //引数のView.subviewsのUIViewにLongPressedを付与
    func addLongPressed(view: UIView){
        print("addLongPressed")
        for item in view.subviews{
            if(type(of: item) == UIView.self && item.tag != 0){
                print("-----")
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(LongPressed(_:)))
                // タップの数（デフォルト0）
                longPress.numberOfTapsRequired = 0
                // 指の数（デフォルト1本）
                longPress.numberOfTouchesRequired = 1
                // 時間（デフォルト0.5秒）
                longPress.minimumPressDuration = 0.5
                // 許容範囲（デフォルト1px）
                longPress.allowableMovement = 150
                //                longPress.delegate = self as? UIGestureRecognizerDelegate
                // tableViewにrecognizerを設定
                if(item.tag >= 1000000000 && item.tag < 10000000000){//やることリストのLongPressを無効化
                    longPress.isEnabled = false //longPress無効化
                }
                item.addGestureRecognizer(longPress)
            }
        }
    }
    
    //メニューをタップで閉じる
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        //タップ直後に中身を実行
        if sender.state == .ended {
            var tapPoint = sender.location(in: self.view)
            if(tapPoint.x <= NewMenuView.frame.minX + 60 && MenuFlag){
                MenuFlag = MenuOC(menu: NewMenuView, scroll: MenuScrollView, flag: MenuFlag)
            }
        }
    }
    
    //タップでタスクを選択する
    @objc func taskSelect(_ sender: UITapGestureRecognizer){
        MoveToRight(scroll: MenuScrollView, animation: true)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.MenuScrollView.contentOffset.y = sender.view!.center.y - 250
            
        }, completion: nil)
        MoveToLeft(scroll: MenuScrollView, cOs: true, border: taskBorder)
    }
    
    func scrollViewFrame(){
        print("scrollViewFrame")
        
        MyScrollView.delegate = self
        MyScrollView.alwaysBounceVertical = true
        _ = CGRect(x: 0, y: 115, width: view.frame.width, height:  667)
        //コンテンツのサイズを指定する
        let contentRect = ContentView.bounds
        MyScrollView.contentSize = CGSize(width: contentRect.width, height: 1720)
    }
    
    var ini_cnt = 0
    func Initialization(){
        print("-----------falization----------")
        //削除予定
        //        if(AlldayView.subviews.count - 2 <= 4){
        //            dummyAll.constant = 50 / 2
        //        }else{
        //            dummyAll.constant = 50
        //        }
        //
        
        day.titleView = getnowTime(content: ContentView)
        deleteViews(content: ContentView, allday: allContentView, menu: menuContentView)
        test_getCalendar()
        craftNewMenu(menu: NewMenuView, scroll: MenuScrollView)//新やることリスト
        craftNewAll(all: AlldayView, scroll: AllScrollView)
        craftCalendar(base_view: ContentView)
        taskBorder = findBorder(scroll: MenuScrollView)
        
        
        print("NewMenuView.subviews")
        for item in MenuScrollView.subviews{
            if type(of: item) ==  UIView.self {
                menuContentView = item
            }
        }
        for i in 1..<menuContentView.subviews.count{
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(ViewController.taskSelect(_:)))
            menuContentView.subviews[i].addGestureRecognizer(tapGesture)
        }
        print("NewAllView.subviews")
        for item in AllScrollView.subviews{
            if type(of: item) ==  UIView.self {
                allContentView = item
            }
        }
        //        for item in allContentView.subviews{
        //            print("1111111")
        //            print(item)
        //        }
        addLongPressed(view: menuContentView)
        print("addLongPressed_allday")
        addLongPressed(view: allContentView)
    }
    
    
    
    func setLabel(){
        print("setLabel")
        let calendar = Calendar.current
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        for i in 0..<24{
            let Label = UILabel(frame: CGRect(x: 10, y: 10 + (i * 60), width: 100, height: 40))
            Label.backgroundColor = UIColor.clear
            Label.font = UIFont(name: "Tsukushi A Round Gothic", size: 11)
            //Label.font = UIFont.systemFont(ofSize: 11)
            Label.text = String((hour+i) % 24) + ":00"
            Label.tag = i+1
            ContentView.addSubview(Label)
            //時間軸の直線
            let topBorder = CALayer()
            topBorder.frame = CGRect(x: 60, y: 30 + (i * 60), width: 300, height: 1)
            topBorder.backgroundColor = UIColor.lightGray.cgColor
            //作成したViewに上線を追加
            ContentView.layer.addSublayer(topBorder)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
//        userDefaultData(content: ContentView)
//        test_addEvent()
        
        try! realm.write{
            let results = realm.objects(DefaultCalendar.self)
            realm.delete(results)
        }
        (UIApplication.shared.delegate as! AppDelegate).calendarFlag = false
    }
    
    
    @objc func deleteView(_ sender: UIButton) {
        print("ボタンの情報: \(sender)")
        let alert: UIAlertController = UIAlertController(title: "このスケジュールを削除しますか？", message: "", preferredStyle:  UIAlertController.Style.alert)
        if(sender.superview!.tag > 10000000000 && sender.superview!.tag <= 100000000000){
            alert.title = "この予定を削除しますか？"
            alert.message = "削除した予定は標準カレンダーからも削除されます"
        }else if(sender.superview!.tag > 1000000000 && sender.superview!.tag <= 10000000000){
            alert.title = "このタスクを削除しますか？"
            alert.message = "削除したタスクはメニューから再度追加できます"
        }
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            let cal_d = self.realm.objects(DefaultCalendar.self)
            let cal_c = self.realm.objects(Calendar24.self)
            
            if(sender.superview!.tag > 10000000000 && sender.superview!.tag <= 100000000000){
                print("デフォルト削除")
                
                let result_d = self.realm.object(ofType: DefaultCalendar.self, forPrimaryKey: String(sender.superview!.tag))
                print(result_d)
                try! self.realm.write{
                    self.realm.cancelWrite() // 処理を止めて
                    self.realm.beginWrite() // また始める
                    self.realm.delete(result_d!)
                }
            }
            if(sender.superview!.tag > 1000000000 && sender.superview!.tag <= 10000000000){
                print("calendar24削除")
                let result_c = self.realm.object(ofType: Calendar24.self, forPrimaryKey: String(sender.superview!.tag))
                let result_t = self.realm.object(ofType: Todo.self, forPrimaryKey: result_c!.todo.first!.todoid)
                print(result_c)
                print(result_t)
                try! self.realm.write{
                    self.realm.cancelWrite() // 処理を止めて
                    self.realm.beginWrite() // また始める
                    self.realm.delete(result_c!)
                    print(result_c)
                    print(result_t!.calendars.count)
                    if(result_t!.calendars.count == 0){
                        result_t?.InFlag = false
                        if(result_t!.base != ""){
                            self.realm.delete(result_t!)
                        }
                    }
                }
            }
            sender.superview?.removeFromSuperview()
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    func animation(){
        ActivityIndicator.startAnimating()
        DispatchQueue.global(qos: .default).async {
            Thread.sleep(forTimeInterval: 5)
            DispatchQueue.main.async {
                self.ActivityIndicator.stopAnimating()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches")
        aTouch = touches.first!
        sTouch = aTouch.location(in: self.view)
        print("sTouch")
        print(sTouch)
    }
    
    // 指が画面に触れ、スクロールが開始した瞬間に呼ばれる
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        if(scrollView == MenuScrollView){
            MoveToRight(scroll: scrollView, animation: true)
        }
        
    }
    
    //リフレッシュ
    func scrollViewDidScroll(_ scrollView: UIScrollView) { //スクロール中
        //print("scrollViewDidScroll")
        if(scrollView == MyScrollView){
            currentPoint = MyScrollView.contentOffset;
            if(currentPoint.y < -100 && animeFlag == 0){
                isRefreshing = true
                UIView.animate(withDuration: 0.3, animations: {
                    // frame分 scrollViewの位置を下げる
                    var newInsets = self.MyScrollView!.contentInset
                    newInsets.top += self.AnimationView.frame.size.height
                    self.MyScrollView!.contentInset = newInsets
                })
                animeFlag = 1
                animation()
            }
            //            print(scrollFlag)
            //            print(location.y)
            //        if(scrollFlag && location.y <= self.view!.frame.size.height - 20 && location.y >= 115){
            //            print("flag")
            //            scrollFlag = false
            //            stopAutoScrollIfNeeded()
            //        }
        }else if(scrollView == MenuScrollView){
            MoveToRight(scroll: scrollView, animation: true)
            MoveToLeft(scroll: scrollView, cOs: false, border: taskBorder)
        }
    }
    
    // 指が画面から離れた瞬間に呼ばれる
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewWillBeginDragging willDecelerate decelerate")
        if(!decelerate){
            if(scrollView == MenuScrollView){
                MoveToLeft(scroll: scrollView, cOs: true, border: taskBorder)
                leftFlag = true
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        if(scrollView == MyScrollView){
            animeFlag = 0
            let now = NSDate()
            let date1 = Calendar.current.dateComponents([.hour], from: now as Date, to: NOW as Date).hour!
            print(NOW)
            print(date1)
            //ActivityIndicator.stopAnimating()
            if(isRefreshing == true){
                UIView.animate(withDuration: 0.3, delay:0.0, options: .curveEaseOut ,animations: {
                    // frame分 scrollViewの位置を上げる（元の位置に戻す）
                    var newInsets = self.MyScrollView!.contentInset
                    newInsets.top -= self.AnimationView.frame.size.height
                    self.MyScrollView!.contentInset = newInsets
                }, completion: {_ in
                    //finished
                })
                reloadView(content: ContentView)
                reloadLabel(content: ContentView)
                //今あるviewを削除(MyScrollView)
                for view in ContentView.subviews{
                    if(type(of: view) == SampleView.self){
                        view.removeFromSuperview()
                    }
                }
                //今あるviewを削除(AlldayView)
                for view in allContentView.subviews{
                    if(type(of: view) == UIView.self){
                        view.removeFromSuperview()
                    }
                }
                craftCalendar(base_view: ContentView)
                craftNewAll(all: AlldayView, scroll: AllScrollView)
//                updateViews(content: ContentView, allday: allContentView)
                day.titleView = getnowTime(content: ContentView)
                isRefreshing = false
            }
        }else if(scrollView == MenuScrollView){
            if(!leftFlag){
                MoveToLeft(scroll: scrollView, cOs: true, border: taskBorder)
            }
        }
    }
    
    //168まで
    var selevtViewCenter = CGPoint()
    //長押し
    @objc func LongPressed(_ sender: UILongPressGestureRecognizer) {
        var scrollFlag = false
        //        var moveView1 = CGPoint()
        //        var moveView2 = CGPoint()
        
        let result_t = realm.object(ofType: Todo.self, forPrimaryKey: String(sender.view!.tag))
        
        let x = sender.self.view!.frame.origin.x
        let y = sender.self.view!.frame.origin.y
        let w = sender.self.view!.frame.size.width
        let center = sender.self.view!.center
        
        //削除予定
        var index = Int()
        var manuflag = Bool()
        //
        
        if(sender.state == UIGestureRecognizer.State.began) {
            print("長押し開始")
//            for view in sender.self.view!.superview!.subviews {
//                print(view.tag)
//            }
//            sender.self.view!.superview!.bringSubviewToFront(sender.self.view!)
//            print("after")
//            for view in sender.self.view!.superview!.subviews {
//
//                print(view.tag)
//            }
            //sender.self.view!.setNeedsDisplay()

            selevtViewCenter = sender.self.view!.center
            moveView1 = sender.self.view!.frame.origin
            
            if(sender.view!.tag > 10000000000 && sender.view!.tag <= 100000000000){ //allday
                if(MenuFlag){
                    MenuFlag = MenuOC(menu: NewMenuView, scroll: MenuScrollView, flag: MenuFlag)
                }
                
            }
            //長押し途中
        }else if(sender.state == UIGestureRecognizer.State.changed){
            //                print(sender.location(in: self.view),dummyAll.constant,MyScrollView.frame.minY)
            location = aTouch.location(in: self.view)
            userY = location.y - (sender.self.view!.frame.height/2)
            let prevLocation = aTouch.previousLocation(in: self.view)
            // ドラッグで移動したx, y距離をとる.
            let deltaX: CGFloat = location.x - prevLocation.x
            let deltaY: CGFloat = location.y - prevLocation.y
            
            if(sender.view!.tag >= 1000000000 && sender.view!.tag < 10000000000){ //Todo
                sender.self.view!.center.x = sender.location(in: self.view).x - NewMenuView.frame.minX
                sender.self.view!.center.y = sender.location(in: self.view).y - MenuScrollView.frame.minY + MenuScrollView.contentOffset.y
            }else if(sender.view!.tag > 10000000000 && sender.view!.tag <= 100000000000){ //allday
                sender.self.view!.center.x = sender.location(in: self.view).x
                sender.self.view!.center.y = sender.location(in: self.view).y - AlldayView.frame.minY + MenuScrollView.contentOffset.y
            }
            
            //                sender.self.view!.center.x += deltaX
            //                sender.self.view!.center.y += deltaY
            
            //オートスクロール  (dummyAll削除につき変更)
            //print(sender.location(in: self.view))
//            if(sender.view!.frame.maxX <= menuContentView.subviews[0].frame.minX && sender.view!.frame.minY > MenuScrollView.frame.minY) {
//                if(!scrollFlag){
//                    if(sender.location(in: self.view).y + sender.self.view!.frame.height/2 > self.view.frame.height - 30){
//                    //if(sender.location(in: self.view).y + sender.self.view!.frame.height/2 > 647){
//                        print("under")
//                        scrollFlag = true
//                        startAutoScroll(duration: 0.05, direction: .under)
//                    }else if(sender.location(in: self.view).y - sender.self.view!.frame.height/2 < MenuScrollView.frame.minY + 30 && sender.location(in: self.view).y - sender.self.view!.frame.height/2 > MenuScrollView.frame.minY){
//                        print("upper")
//                        scrollFlag = true
//                        startAutoScroll(duration: 0.05, direction: .upper)
//                    }
//                }
//                if(sender.location(in: self.view).y + sender.self.view!.frame.height/2 <= self.view.frame.height - 30 && sender.location(in: self.view).y - sender.self.view!.frame.height/2 >= MenuScrollView.frame.minY + 30){
//                    scrollFlag = false
//                    stopAutoScrollIfNeeded()
//                }
//            }
            print(sender.location(in: self.view).y - sender.self.view!.frame.height/2, sender.location(in: self.view).y + sender.self.view!.frame.height/2 )
//            print(sender.view!.frame.maxX,menuContentView.subviews[0].frame.minX,sender.view!.frame.minY, MyScrollView.frame.minY,(self.navigationController?.navigationBar.frame.size.height)!, AlldayView.frame.height)
            //sender.self.view!.center = sender.location(in: self.view)
            //長押し終了
        }else if(sender.state == UIGestureRecognizer.State.ended){
            print("長押し終了")
            
            //ContentViewにドロップした場合
            
            print("moveManu")
            let savetag = sender.view!.tag
            //ManuViewのタスクが移動された場合
            
            if(sender.view!.tag >= 1000000000 && sender.view!.tag < 10000000000){ //Todo
                if(sender.view!.frame.maxX <= menuContentView.subviews[0].frame.minX && sender.view!.frame.minY > MyScrollView.frame.minY) {
                    //削除ボタン作成
                    let button :UIButton = UIButton(frame: CGRect(x: 285,y: 0,width: 15,height: 15))
                    button.setImage(UIImage(named:"close_black"), for: .normal)
                    button.addTarget(self, action: #selector(deleteView(_:)), for: UIControl.Event.touchUpInside)
                    //                        traceView(userY: userY - CGFloat(65 + dummyAll.constant), height: sender.view!.frame.height, tag: sender.view!.tag, content: ContentView, ReturnButton: button)
                    var pointY = sender.location(in: self.view).y - sender.self.view!.frame.height/2 - CGFloat(MyScrollView.frame.minY) + MyScrollView.contentOffset.y
                    traceView(userY: pointY, height: sender.view!.frame.height, tag: sender.view!.tag, content: ContentView, ReturnButton: button)
                    
                    
                    print("view戻す")
                    
                    
                }
                sender.view!.center = selevtViewCenter
                MoveToRight(scroll: MenuScrollView,animation: false)
                
                
                
            }else if(sender.view!.tag > 10000000000 && sender.view!.tag <= 100000000000){ //allday
                if(sender.view!.frame.minY > AlldayView.frame.height) {
                    let button = makeButton()
                    var pointY = sender.location(in: self.view).y - sender.self.view!.frame.height/2 - CGFloat(MyScrollView.frame.minY) + MyScrollView.contentOffset.y
                    traceView(userY: pointY, height: sender.self.view!.frame.height, tag: sender.view!.tag, content: ContentView, ReturnButton: button)
                    //                    traceView(userY: userY - CGFloat(MyScrollView.frame.minY), height: sender.self.view!.frame.height, tag: sender.view!.tag, content: ContentView, ReturnButton: button)
                    sender.view!.removeFromSuperview()
                    for View in allContentView.subviews{
                        print("---------いどう-----------")
                        print(moveView1)
                        print(View.frame.origin)
                        if(moveView1.x < View.frame.origin.x){//選択されたViewよりも右側にあるviewを動かす
                            print("移動した")
                            moveView2 = allContentView.viewWithTag(View.tag)!.frame.origin
                            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                                self.allContentView.viewWithTag(View.tag)!.frame.origin = CGPoint(x: self.moveView1.x, y: self.moveView1.y)
                            }, completion: nil)
                            allContentView.viewWithTag(View.tag)!.frame.origin = moveView1
                            moveView1 = moveView2
                        }
                    }
                    
                    //                    削除予定
                    //                    if(dummyAllFlag){
                    //                        dummyAll.constant = 25 + CGFloat((AlldayView.subviews.count / 4) * 25)
                    //                    }
                }else {
                    sender.view!.center = selevtViewCenter
                }
            }
            
            scrollFlag = false
            stopAutoScrollIfNeeded()
        }
    }
    
    
    
    
    func startAutoScroll(duration: TimeInterval, direction: ScrollDirectionType) {
        // 表示されているTableViewのOffsetを取得
        var currentOffsetY = MyScrollView.contentOffset.y
        // 自動スクロールを終了させるかどうか
        var shouldFinish = false
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            // 10ずつY軸のoffsetを変更していく
            switch direction {
            case .upper:
                currentOffsetY = (currentOffsetY - 10 < 0) ? 0 : currentOffsetY - 10
                shouldFinish = currentOffsetY == 0
            case .under:
                let highLimit = self.MyScrollView.contentSize.height - self.MyScrollView.bounds.size.height
                currentOffsetY = (currentOffsetY + 10 > highLimit) ? highLimit : currentOffsetY + 10
                shouldFinish = currentOffsetY == highLimit
            default: break
            }
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration * 2, animations: {
                    self.MyScrollView.setContentOffset(CGPoint(x: 0, y: currentOffsetY), animated: false)
                }, completion: { _ in
                    if shouldFinish { self.stopAutoScrollIfNeeded()}
                })
            }
        })
    }
    
    // 自動スクロールを停止する
    func stopAutoScrollIfNeeded() {
        //print("------------------------------------------------------")
        if (autoScrollTimer.isValid) {
            print("#######3333333333333333333333333333333333333333333")
            MyScrollView.layer.removeAllAnimations()
            autoScrollTimer.invalidate()
        }
    }
    
    enum ScrollDirectionType {
        case upper, under, left, right
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        print("touch")
    }
}

extension UIFont {
    var bold: UIFont { return withWeight(.bold) }
    var semibold: UIFont { return withWeight(.semibold) }
    
    private func withWeight(_ weight: UIFont.Weight) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        
        traits[.weight] = weight
        
        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = familyName
        
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

extension UIColor {
    
    func dark(brightnessRatio: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * brightnessRatio, alpha: alpha)
        } else {
            return self
        }
    }
}

extension UIViewController {
    var className: String {
        return String(describing: type(of: self))
    }
}

