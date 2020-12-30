//
//  SampleView.swift
//  nextCalendar
//
//  Created by 牧内秀介 on 2019/09/27.
//  Copyright © 2019 Swift-Biginners. All rights reserved.
//

import Foundation
import UIKit

class SampleView :UIView {
    
    var no1point: Int = 30
    var no23point: Int = 1410
    let screen = ScreenSize()
    
    var aTouch = UITouch()
    
    let radius: CGFloat = 5.0
    
    var imageView = UIImageView(image:UIImage(named:"chevron-down")!)
    
    let circle = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
    
    let title: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 300,height: 15))
    let fake_taskTime: UILabel = UILabel(frame: CGRect(x: 100,y: 0,width: 50,height: 10))
    
    let taskTime: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 50,height: 15))
    let startTime: UILabel = UILabel(frame: CGRect(x: 0,y: 30,width: 100,height: 10))
    let endTime: UILabel = UILabel(frame: CGRect(x: 50,y: 30,width: 100,height: 10))
    let dotimeLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 15))
    
    let content = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 15))
    let leftBorder = UIView()
    
    
    var fakeView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    
    
    override init(frame: CGRect) {
        
        no1point = screen.no1point
        no23point = screen.no23point
        
        super.init(frame: frame)
        var color :UIColor = UIColor.black
        
        
        fake_taskTime.textColor = UIColor.white
        startTime.textColor = UIColor.white
        title.textColor = UIColor.white
        //        var font = UIFont(name: "Tsukushi A Round Gothic", size: 10)
        //        title.font = font?.bold
        title.font = UIFont.boldSystemFont(ofSize: 13)
        title.layer.masksToBounds = true
        title.layer.cornerRadius = 4
        title.backgroundColor = color
        //        endTime.textColor = UIColor.white
        
        //        imageView.frame = CGRect(x:300, y: 588, width:59, height:59)
        //        imageView.alpha = 1.0
        //        self.superview?.addSubview(imageView)
        
        //imageView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height - 10)
        //taskTime.font = taskTime.font.withSize(15.0)
        
        //content.addSubview(startTime)
        
        //        self.addSubview(endTime)
        //        self.addSubview(myLabel)
        
        //scrollView.contentSize = CGSize(width: 200, height: content.bounds.height)
        content.frame.size = CGSize(width: self.frame.size.width, height: self.frame.size.height - 20 * screen.calScale)
        
        //content.backgroundColor = color
        content.alpha = 0.3
        self.addSubview(content)
        
        leftBorder.frame = CGRect(x: 0, y: 0, width: 1, height: content.frame.size.height)
        leftBorder.backgroundColor = color
        self.addSubview(leftBorder)
        
        
        
        circle.layer.cornerRadius = circle.frame.size.width / 2.0
        circle.center = CGPoint(x: self.frame.size.width/2, y: self.content.frame.size.height)
        circle.backgroundColor = UIColor.red
        circle.clipsToBounds = true
        //circle.layer.borderColor = UIColor.black.cgColor
        //circle.layer.borderWidth = 2
        //        let doTime = content.frame.size.height
        //        let timetext = String(format: "%02dh %02dm", Int(doTime/60), Int(round(Double(doTime) - Double(60*Int(doTime/60)))))
        //        dotimeLabel.text = "目標時間：" + timetext
        dotimeLabel.frame.origin.y = content.frame.size.height - 15
        dotimeLabel.textColor = UIColor.black
        dotimeLabel.font = UIFont(name: "Tsukushi A Round Gothic", size: 12)
        dotimeLabel.textAlignment = NSTextAlignment.right
        dotimeLabel.alpha = 2.0
        self.addSubview(dotimeLabel)
        
        taskTime.textColor = UIColor.white
        taskTime.frame.origin.y = content.frame.size.height - 15
        taskTime.font = UIFont.italicSystemFont(ofSize: 12)
        taskTime.textAlignment = NSTextAlignment.left
        taskTime.alpha = 0.0
        self.addSubview(taskTime)
        
        
        fakeView.backgroundColor = color
        fakeView.frame = self.content.frame
        fakeView.addSubview(title)
        //fakeView.addSubview(fake_taskTime)
        
        //self.addSubview(imageView)
        
        
        //self.layer.borderColor = UIColor.black.cgColor
        //self.layer.borderWidth = 2
        
        
        self.addSubview(circle)
        
        getTaskTime_S()
        
        //        print("bfgosuezhfnclbvshgorue")
        //        print(self.superview!.superview?.superview)
        
        
        //        for view in (self.superview?.superview?.superview?.subviews)! {
        //            if type(of: view) ==  UIImageView.self{
        //                print("view", view)
        //            }
        //        }
        
        //panジェスチャーのインスタンスを作成する
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        //        let circlePan = UIPanGestureRecognizer(target: self, action: #selector(self.circlePanGesture(_:)))
        //        //ジェスチャーを追加する
        self.addGestureRecognizer(gesture)
        //        self.circle.addGestureRecognizer(circlePan)
        
    }
    
    var scrollFlag = false
    var tracedView = [SampleView]()
    var alltracedView = [SampleView]()
    
    @objc func panGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("panGesture")
        let hour = (no23point - no1point)/23
        let minute:Double
        var point: CGPoint
        var p: CGPoint
        var movedCenterPoint: CGPoint
        var movedPoint: CGPoint
        var movedUnderPoint: CGPoint
        var changedheight: Double
        
        var separate:Double = Double(hour/4)
        
        minute = Double(hour)/Double(60)
        if(gestureRecognizer.state == .began){
            if(gestureRecognizer.location(in: self).y > content.frame.height - 30 * screen.calScale && gestureRecognizer.location(in: self).x > circle.center.x - 50 * screen.calScale && gestureRecognizer.location(in: self).x < circle.center.x + 50 * screen.calScale){
                flag = 1
            }else {
                flag = 0
            }
            for label in self.subviews{
                if type(of: label) == UILabel.self {
                    title.text = (label as! UILabel).text
                }
            }
            
            content.alpha = 1.0
            alltracedView = []
            tracedView = []
            for sampleview in self.superview!.subviews{
                if type(of: sampleview) == SampleView.self {
                    if(sampleview != gestureRecognizer.view){
                        tracedView.append(sampleview as! SampleView)
                    }
                    alltracedView.append(sampleview as! SampleView)
                }
            }
        }
        
        if(flag == 1){
            if(gestureRecognizer.state == .began){
                taskTime.alpha = 1.0
            }
            //移動量を取得する
            //if(gestureRecognizer.state == .changed){
            var move = gestureRecognizer.translation(in: self)
            movedCenterPoint = CGPoint(x: gestureRecognizer.view!.center.x + move.x, y: gestureRecognizer.view!.center.y + move.y)
            movedUnderPoint = CGPoint(x: movedCenterPoint.x - self.frame.size.width/2 ,y: movedCenterPoint.y + self.frame.size.height/2)
            
            if(content.frame.size.height + move.y > CGFloat(15 * minute)){
                self.frame.size.height += move.y
                content.frame.size.height += move.y
                leftBorder.frame.size.height += move.y
            }else if(Double(self.content.frame.size.height + move.y) <= 15 * minute && move.y < 0){
                //move.y = 0
                self.frame.size.height = CGFloat(15 + 20) * CGFloat(minute)
                content.frame.size.height = CGFloat(15 * minute)
                leftBorder.frame.size.height = CGFloat(15 * minute)
            }
            if(content.frame.size.height + move.y > CGFloat(300 * minute)){
                self.frame.size.height = CGFloat(300 + 20) * CGFloat(minute)
                content.frame.size.height = CGFloat(300 * minute)
                leftBorder.frame.size.height = CGFloat(300 * minute)
            }
            
            //scrollView.contentSize = CGSize(width: 200, height: content.bounds.height)
            dotimeLabel.frame.origin.y = content.frame.size.height - 15
            taskTime.frame.origin.y = content.frame.size.height - 15
            
            circle.center = CGPoint(x: self.frame.size.width/2, y: self.content.frame.size.height)
            imageView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height - 10)
            //移動量をリセットする
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            //}
            if(gestureRecognizer.state == .ended){
                taskTime.alpha = 0.0
                userDefaultData(view: self)
                if(self.tag > 10000000000 && self.tag <= 100000000000){ //default
                    print("default")
                    new_addEvent(tag: self.tag)
                }
            }
            
            
        }else if(flag == 0){
            if(gestureRecognizer.state == .began){
                self.alpha = 0.0
                print("self",self)
                // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
                fakeView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                // 影の色
                fakeView.layer.shadowColor = UIColor.black.cgColor
                // 影の濃さ
                fakeView.layer.shadowOpacity = 0.6
                // 影をぼかし
                fakeView.layer.shadowRadius = 4
                fakeView.frame = CGRect(x: 60, y: self.frame.origin.y + (self.superview?.superview as! UIScrollView).frame.origin.y - (self.superview?.superview as! UIScrollView).contentOffset.y, width: self.content.frame.size.width, height: self.content.frame.size.height)
                
            }
            location = aTouch.location(in: fakeView) //in: には対象となるビューを入れます
            
            point = gestureRecognizer.translation(in: self)
            movedCenterPoint = CGPoint(x: gestureRecognizer.view!.center.x + point.x, y: gestureRecognizer.view!.center.y + point.y)
            movedPoint = CGPoint(x: movedCenterPoint.x - self.frame.size.width/2 ,y: movedCenterPoint.y - self.frame.size.height/2)
            if(gestureRecognizer.state == .changed){
                print("gesloc",gestureRecognizer.location(in: self).y)
                //fakeView.frame.origin.x = movedPoint.x
                fakeView.frame.origin.y += point.y
                gestureRecognizer.view!.center.y = fakeView.center.y + (self.superview?.superview as! UIScrollView).contentOffset.y - (self.superview?.superview as! UIScrollView).frame.origin.y +     10
                //print("location",location)
                //print(self.frame.origin.y, fakeView.frame.origin.y)
                print(gestureRecognizer.view!.frame.minY,gestureRecognizer.view!.frame.maxY)
                //print(movedPoint.y - (self.superview?.superview as! UIScrollView).contentOffset.y)
                imageView.alpha = 1.0
                if(!scrollFlag){
                    if(fakeView.frame.maxY > (self.superview?.superview as! UIScrollView).frame.maxY - CGFloat(60 * minute)){
                        print("under")
                        scrollFlag = true
                        startAutoScroll(duration: 0.05, direction: .under)
                    }else if(fakeView.frame.minY < (self.superview?.superview as! UIScrollView).frame.minY + CGFloat(60 * minute)){
                        
                        print("upper")
                        scrollFlag = true
                        startAutoScroll(duration: 0.05, direction: .upper)
                    }
                }
                if(fakeView.frame.maxY <= (self.superview?.superview as! UIScrollView).frame.maxY - CGFloat(60 * minute) && fakeView.frame.minY >= (self.superview?.superview as! UIScrollView).frame.minY + CGFloat(60 * minute)){
                    scrollFlag = false
                    stopAutoScrollIfNeeded()
                }
                //self.removeFromSuperview()
                self.superview?.superview?.superview?.addSubview(fakeView)
                
            }
            
            //gestureRecognizer.view!.center = movedCenterPoint
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
            if(gestureRecognizer.state == .ended){
                fakeView.layer.shadowOpacity = 0.0
                //stopAutoScrollIfNeeded()
                point = gestureRecognizer.translation(in: self)
                movedCenterPoint = CGPoint(x: gestureRecognizer.view!.center.x + point.x, y: gestureRecognizer.view!.center.y + point.y)
                movedPoint = CGPoint(x: movedCenterPoint.x - self.frame.size.width/2 ,y: movedCenterPoint.y - self.frame.size.height/2)
                fakeView.frame.origin.y -= (self.superview?.superview as! UIScrollView).frame.origin.y
                
                self.frame.origin.y = fakeView.frame.origin.y + (self.superview?.superview! as! UIScrollView).contentOffset.y
                fakeView.frame.origin.y -= (self.superview?.superview! as! UIScrollView).contentOffset.y
                fakeView.removeFromSuperview()
                self.alpha = 1.0
                location = aTouch.location(in: self)
                //(Double(movedPoint.y) - 30) / separate
                for i in 0..<92 {
                    if(Double(movedPoint.y) > Double(no1point) + Double(hour*i/4) && Double(movedPoint.y) <= Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                        self.frame.origin.y = CGFloat(Double(no1point) + Double(hour*i/4))
                        print("center",movedCenterPoint.y,i)
                        print(self.frame.origin)
                    }else if(Double(movedPoint.y) <= Double(no1point) + Double(hour*(i+1)/4) && Double(movedPoint.y) > Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                        self.frame.origin.y = CGFloat(Double(no1point) + Double(hour*(i+1)/4))
                        print("center",movedCenterPoint.y)
                        print(self.frame.origin)
                    }
                }
                //                overLaped()
                scrollFlag = false
                stopAutoScrollIfNeeded()
                imageView.alpha = 0.0
                userDefaultData(view: self)
                if(self.tag > 10000000000 && self.tag <= 100000000000){ //default
                    print("default")
                    new_addEvent(tag: self.tag)
                }
            }
        }
        getTaskTime_S()
        if(gestureRecognizer.state == .ended){
            content.alpha = 0.3
            
        }
    }
    
    func getTaskTime_S(){
        for v in self.subviews {
            // オブジェクトの型がUIImageView型で、タグ番号が1〜5番のオブジェクトを取得する
            if let v = v as? UILabel, v.tag == 100  {
                // そのオブジェクトを親のviewから取り除く
                v.removeFromSuperview()
            }
        }
        let hour = (no23point - no1point)/23
        let minute:Double
        minute = Double(hour)/Double(60)
        
        let format = DateFormatter()
        
        let calendar = Calendar.current
        let date = Date()
        let m = calendar.component(.minute, from: date)
        
        let starttime = Int(round(Double(Double(self.frame.origin.y) - Double(no1point)) / minute)) - m
        //let endtime = Int(round(Double(Int(self.frame.origin.y) + Int(self.frame.size.height) - no1point) / minute)) - m
        //print(starttime)
        let startDate = Calendar.current.date(byAdding: .minute, value: starttime, to: date)!
        //let endDate = Calendar.current.date(byAdding: .minute, value: endtime, to: date)!
        
        format.dateFormat = "HH:mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        startTime.text = format.string(from: startDate)
        //endTime.text = format.string(from: endDate)
        
        // var tasktime = Double(endtime - starttime)
        var tasktime = Double(self.content.frame.size.height) / minute
        let timetext = String(format: "%d:%02d", Int(tasktime/60), Int(tasktime - Double(60*Int(tasktime/60))))
        
        taskTime.text = " " + String(timetext)
        fake_taskTime.text = " " + String(timetext)
    }
    
    
    func userDefaultData(view: SampleView){
        print("userDefaultData-sample")
        let dateFormater = DateFormatter()//開始時間用
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd"
        dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
        print("userDefaultData-Content.subviews")
        //かける 追加12/30
        let f = DateFormatter()//日付用
        f.timeStyle = .none
        f.dateStyle = .full
        f.locale = Locale(identifier: "ja_JP")
        //        for view in content.subviews{
        //            if(type(of: view) == SampleView.self){
        print(view.tag)
        print(view)
        let start = getTaskTime(y: view.frame.origin.y)
        print("startTime---")
        print(start)
        let dotime = Int((view.frame.height - (20 * screen.calScale)) * 60 / screen.calScale)
        //            let end = convert_string_details(date: Calendar.current.date(byAdding: .second, value: dotime, to: startTime)!)
        if(view.tag > 1000000000 && view.tag < 10000000000){ //calendar24
            try! realm.write{
                let day = start
                let end = Calendar.current.date(byAdding: .second, value: dotime, to: day)!
                let item = realm.object(ofType: Calendar24.self, forPrimaryKey: String(view.tag))
//                item!.start = start
//                item!.c_dotime = dotime
//                item!.end = end
                //かける追加 12/30
                //指定なしタスクの開始時間を変更した際のデータの動き
                let results = realm.objects(Todo.self).filter("base!=%@","")//指定なしから複製されてるものを検索
                //data：選択しているタスクのTodo
                //search_Todo：変更先のTodo
                for data in results{
                    for i in 0..<data.calendars.count{
                        //変更したViewをTodoのcalednarsから検索
                        if(data.calendars[i].calendarid == String(view.tag)){
                            if(data.datestring != f.string(from: start)){
//                                data.datestring = f.string(from: start)
                                
                                //変更するデータのbaseが同じかつtodoidが異なるデータを検索
                                let search_Todo = realm.objects(Todo.self).filter("base==%@", data.base).filter("todoid!=%@", data.todoid)
                                
                                //item(移動させるcalendar24データ)を複製
                                let new_cal = Calendar24()
                                
                                new_cal.calendarid = item!.calendarid
                                
                                new_cal.todoDone = item!.todoDone
                                new_cal.start = start  //開始時間だけ変更
                                new_cal.default_allday = item!.default_allday
                                new_cal.c_dotime = item!.c_dotime
                                new_cal.end = end
                                if(search_Todo.count > 0){
                                    
                                    for search_data in search_Todo{
                                        
                                        
                                        //追加先の開始時間が同じだった時
                                        if(search_data.datestring == f.string(from: start)){
                                            realm.delete(item!)
                                            search_data.calendars.append(new_cal)
                                            
                                            if(data.calendars.count == 0){
                                                realm.delete(data)
                                            }
                                            break
                                        }else{
                                            
//                                            if(search_Todo[l].calendars.count == 0){
                                                let new_todo = Todo()
                                                new_todo.todoid = randomString(length: 10)
                                                new_todo.title = String(data.title)
                                                new_todo.todoDone = false
                                                new_todo.donetime = 0
                                                new_todo.dotime = data.dotime
                                                new_todo.date = start
                                                new_todo.datestring = f.string(from: start)
                                                new_todo.InFlag = true
                                                new_todo.base = data.base
                                                realm.add(new_todo)
                                                
                                                realm.delete(item!)
                                                new_todo.calendars.append(new_cal)
                                                
//                                            }
//                                            data.datestring = f.string(from: start)
//                                            realm.delete(item!)
//                                            search_Todo.first?.calendars.append(new_cal)
                                            if(data.calendars.count == 0){
                                                realm.delete(data)
                                            }
                                            break
                                        }
                                    }
                                }else{
                                    let new_todo = Todo()
                                    new_todo.todoid = randomString(length: 10)
                                    new_todo.title = String(data.title)
                                    new_todo.todoDone = false
                                    new_todo.donetime = 0
                                    new_todo.dotime = data.dotime
                                    new_todo.date = start
                                    new_todo.datestring = f.string(from: start)
                                    new_todo.InFlag = true
                                    new_todo.base = data.base
                                    realm.add(new_todo)
                                    realm.delete(item!)
                                    new_todo.calendars.append(new_cal)
                                    if(data.calendars.count == 0){
                                        realm.delete(data)
                                    }
                                    break
                                }
                            }
                        }
                    }
                    
                }
                
            }
        }else if(view.tag >= 10000000000){ //default
            try! realm.write{
                let day = start
                let end = Calendar.current.date(byAdding: .second, value: dotime, to: day)!
                let item = realm.object(ofType: DefaultCalendar.self, forPrimaryKey: String(view.tag))
                item!.start = start
                item!.c_dotime = dotime
                item!.end = end
                print(start)
                print(end)
            }
        }
    }
    
    var location = CGPoint()
    var flag = 0
    func overLaped() {
        print(tracedView)
        var lap = 0
        var i = 0
        for view in tracedView{
            print(view.frame)
            if((self.frame.origin.y >= view.frame.origin.y && self.frame.origin.y < view.frame.origin.y + view.content.frame.size.height) || (self.frame.origin.y + self.content.frame.size.height  > view.frame.origin.y && self.frame.origin.y + self.content.frame.size.height <= view.frame.origin.y + view.content.frame.size.height)){
                lap += 1
            }
        }
        for view in tracedView{
            print(view.frame)
            if((self.frame.origin.y >= view.frame.origin.y && self.frame.origin.y < view.frame.origin.y + view.content.frame.size.height) || (self.frame.origin.y + self.content.frame.size.height  > view.frame.origin.y && self.frame.origin.y + self.content.frame.size.height <= view.frame.origin.y + view.content.frame.size.height)){
                i += 1
                
                print("overlaped")
                self.frame.origin.x = CGFloat(60)
                self.frame.size.width = CGFloat(300 / (lap+1))
                self.content.frame.size.width = CGFloat(300 / (lap+1))
                self.circle.center.x = self.frame.size.width / 2
                for object in self.subviews {
                    if type(of: object) == UILabel.self {
                        object.frame.size.width = CGFloat(300 / (lap+1))
                    }
                    if type(of: object) == UIButton.self {
                        object.frame.origin.x = self.frame.size.width - 15
                    }
                }
                
                var v = self.superview!.viewWithTag(view.tag) as! SampleView
                v.frame.origin.x = CGFloat(60 + (300 / (lap+1)) * i)
                v.frame.size.width = CGFloat(300 / (lap+1))
                v.content.frame.size.width = CGFloat(300 / (lap+1))
                v.circle.center.x = v.frame.size.width / 2
                for object in v.subviews {
                    if type(of: object) == UILabel.self {
                        object.frame.size.width = CGFloat(300 / (lap+1))
                    }
                    if type(of: object) == UIButton.self {
                        object.frame.origin.x = self.frame.size.width - 15
                    }
                }
            }
        }
        if(lap == 0){
            self.frame.origin.x = CGFloat(60)
            self.frame.size.width = CGFloat(300)
            self.content.frame.size.width = CGFloat(300)
            self.circle.center.x = self.frame.size.width / 2
            for object in self.subviews {
                if type(of: object) == UILabel.self {
                    object.frame.size.width = CGFloat(300)
                }
                if type(of: object) == UIButton.self {
                    object.frame.origin.x = self.frame.size.width - 15
                }
            }
        }
    }
    
    func overLap() {
        for view1 in alltracedView{
            var cnt = 0
            var indexs = [Int]()
            var view = [SampleView]()
            for view2 in alltracedView{
                if(view1 != view2 && view1.content.frame.origin.y >= view2.content.frame.origin.y && view1.content.frame.origin.y < view2.content.frame.origin.y + view2.content.frame.size.height){
                    cnt += 1
                    view.append(view2)
                    indexs.append(alltracedView.firstIndex(of: view2)!)
                }
            }
            //view1.frame.size.width = CGRect(300 / indexs.count)
            for i in 0..<indexs.count {
                alltracedView[i].frame.origin.x = CGFloat((300/indexs.count) * (i+1) + 60)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
        location = touch.location(in: self) //in: には対象となるビューを入れます
        print(location)
        if(location.y >= circle.center.y - 15 && location.y <= circle.center.y + 15){
            if(location.x >= circle.center.x - 15  && location.x <= circle.center.x + 15){
                print("circleIn")
                flag = 1
            }else{
                print("circleOut")
                flag = 0
            }
        }else {
            print("circleOut")
            flag = 0
        }
    }
    
    var autoScrollTimer = Timer()
    
    func startAutoScroll(duration: TimeInterval, direction: ScrollDirectionType) {
        // 表示されているTableViewのOffsetを取得
        var currentOffsetY = (self.superview?.superview! as! UIScrollView).contentOffset.y
        print(currentOffsetY)
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
                let highLimit = (self.superview?.superview as! UIScrollView).contentSize.height - (self.superview?.superview as! UIScrollView).bounds.size.height
                currentOffsetY = (currentOffsetY + 10 > highLimit) ? highLimit : currentOffsetY + 10
                shouldFinish = currentOffsetY == highLimit
            default: break
            }
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration * 2, animations: {
                    (self.superview?.superview as! UIScrollView).setContentOffset(CGPoint(x: 0, y: currentOffsetY), animated: false)
                }, completion: { _ in
                    if shouldFinish { self.stopAutoScrollIfNeeded() }
                })
            }
        })
    }
    
    // 自動スクロールを停止する
    func stopAutoScrollIfNeeded() {
        //print("------------------------------------------------------")
        if (autoScrollTimer.isValid) {
            print("#######3333333333333333333333333333333333333333333")
            (self.superview?.superview as! UIScrollView).layer.removeAllAnimations()
            autoScrollTimer.invalidate()
        }
    }
    
    enum ScrollDirectionType {
        case upper, under, left, right
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


