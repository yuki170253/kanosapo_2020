//
//  craftMenu.swift
//  MyTodoList
//
//  Created by 牧内秀介 on 2020/10/06.
//  Copyright © 2020 古府侑樹. All rights reserved.
//

import UIKit
import Foundation

import EventKit
import RealmSwift

let startPosi = CGFloat(70)
let realm = try! Realm()
let TaskColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
let AlldayColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)

func craftNewMenu(menu:UIView, scroll:UIScrollView) {
    print("craftNewMenu")
    let DummyContentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: menu.frame.size.width, height: 2000))
    
    let WhiteView = UIView.init(frame: CGRect.init(x: 55 * screen.calScale, y: -500, width: menu.frame.size.width, height: 30000))
    WhiteView.frame.size.width -= WhiteView.frame.origin.x
    let bgColor = #colorLiteral(red: 0.8745098039, green: 0.8705882353, blue: 0.8980392157, alpha: 1)
    WhiteView.backgroundColor = bgColor
    let leftBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 1, height: WhiteView.frame.size.height))
    leftBorder.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    WhiteView.addSubview(leftBorder)
    print(DummyContentView.tag)
    print(WhiteView.tag)
    scroll.clipsToBounds = false // scrollview外に出ても表示される
    scroll.addSubview(DummyContentView)
    
    DummyContentView.addSubview(WhiteView)
    
    //かける追加
    let f = DateFormatter()
    f.timeStyle = .none
    f.dateStyle = .full
    f.locale = Locale(identifier: "ja_JP")
    let Now = NSDate() as Date
    let date = f.string(from: Now)
    let result_m = realm.objects(Todo.self).filter("datestring == '指定なし'").filter("todoDone==false")
    let result_s = realm.objects(Todo.self).filter("datestring == %@", date).filter("todoDone==false")
    var task_cnt = 0  //追加したViewの個数を数える
    print("タスクView作成")
    for item in result_s{
        print(item.base)
        if(item.base != ""){
            continue
        }
        let frame = CGRect(x: startPosi * screen.calScale, y: CGFloat(task_cnt) * 100 * screen.calScale + scroll.frame.size.height/2, width: 100 * screen.calScale, height: 45 * screen.calScale)
        let TestView = makeTaskView(frame: frame, tag: Int(item.todoid)!, title: item.title)
        TestView.center.x = WhiteView.center.x
        TestView.backgroundColor = TaskColor
        DummyContentView.addSubview(TestView)
        task_cnt += 1
        
    }
    for item in result_m{
//        let results = realm.objects(Todo.self).filter("base==%@", item.todoid).filter("datestring==%@", date)
//        var tag = String()
//        var title = String()
//        if(results.count == 0){//指定なしタスクを複製していない場合
//            tag = item.todoid
//            title = item.title
//        }else{//指定なしタスクを複製していた場合
//            for result in results{
//                tag = result.todoid
//                title = result.title
//            }
//        }
        let frame = CGRect(x: startPosi * screen.calScale, y: CGFloat(task_cnt) * 100 * screen.calScale + scroll.frame.size.height/2, width: 100 * screen.calScale, height: 45 * screen.calScale)
        let TestView = makeTaskView(frame: frame, tag: Int(item.todoid)!, title: item.title)
        TestView.center.x = WhiteView.center.x
        TestView.backgroundColor = AlldayColor
        DummyContentView.addSubview(TestView)
        task_cnt += 1
    }
    //かける追加終了
    //スクロールViewサイズ確定
    let cnt = DummyContentView.subviews.count
//    scroll.frame.size.height = (CGFloat(CGFloat((cnt - 1) * 100) * screen.calScale) + screen.screenHeight - screen.screenHeight/5) * screen.calScale
    scroll.contentSize = CGSize(width:scroll.frame.size.width , height:CGFloat(CGFloat(CGFloat((cnt - 1)) * CGFloat(100)) * screen.calScale) + screen.screenHeight - screen.screenHeight/5)
    DummyContentView.frame.size.height = CGFloat(CGFloat((cnt - 1)) * CGFloat(100) * screen.calScale) + screen.screenHeight - screen.screenHeight/5
    //    scroll.contentSize = CGSize(width:scroll.frame.size.width , height:CGFloat(680))
}

func craftNewAll(all: UIView, scroll: UIScrollView){
    scroll.clipsToBounds = false // scrollview外に出ても表示される
    let contentsView = UIView.init(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(1000), height: CGFloat(scroll.frame.height)))
    scroll.addSubview(contentsView)
    let result_d = realm.objects(DefaultCalendar.self)
    var task_cnt = 0  //追加したViewの個数を数える
    for item in result_d{
        if(item.allDay){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            if(dateFormatter.string(from: item.start) == dateFormatter.string(from: Date())){
                print(item)
                let frame = CGRect(x: CGFloat(5 + 120 * Int(screen.calScale) * task_cnt), y: 18 * screen.calScale, width: 100 * screen.calScale, height: 28 * screen.calScale)
                let TestView = makeTaskView(frame: frame, tag: Int(item.calendarid)!, title: item.title)
                let color = UIColor(displayP3Red: CGFloat(item.color_r), green: CGFloat(item.color_g), blue: CGFloat(item.color_b), alpha: 1.0)
                TestView.backgroundColor = color
                contentsView.addSubview(TestView)
                task_cnt += 1
            }
        }
    }
    let cnt = contentsView.subviews.count
    scroll.contentSize = CGSize(width: CGFloat(CGFloat(cnt * 120) + screen.screenWidth/5), height: scroll.frame.size.height)
    //    scroll.contentSize = contentsView.frame.size
}


func MenuOC(menu:UIView, scroll:UIScrollView, flag:Bool) -> Bool {
    var f = Bool()
    if(!flag){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            menu.frame.origin.x -= menu.frame.size.width
            f = true
        }, completion: nil)
        
    }else{
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            menu.frame.origin.x += menu.frame.size.width
            f = false
        }, completion: nil)
        MoveToRight(scroll: scroll,animation: true)
    }
    return f
}

func MoveToLeft(scroll:UIScrollView, cOs:Bool, border:[CGFloat]){
    print("MoveToLeft")
    var views = [UIView]()
    for view in scroll.subviews{
        if type(of: view) ==  UIView.self {
            views = view.subviews
        }
    }
    for i in 0..<border.count {
        if(scroll.contentOffset.y < border[i] || border.count == 1){
            //目標時間にheightを合わせる
            let no1point = ScreenSize().no1point
            let no23point = ScreenSize().no23point
            let hour = (no23point - no1point)/23
            let minute:Double
            minute = Double(hour)/Double(60)
            let result = realm.object(ofType: Todo.self, forPrimaryKey: String(views[i+1].tag))
            let dotime = Double(result!.dotime) / 60
            var size = CGFloat(Double(dotime) * minute)
            if size < 15 {
                size = 15
            }
            let h = views[i+1].frame.size.height
            let center = views[i+1].center
            //            let size = CGFloat(views[i+1].tag)
            
//            let color = views[i+1].backgroundColor!
//
//            if(result?.datestring == "指定なし"){
//                color = UIColor.purple
//            }else{
//                color = TaskColor
//            }
            
            var labelColor = UIColor.white
            if result!.datestring == "指定なし"{
                labelColor = UIColor.black
            }
            let gradation = CGFloat(0.15)
            //            for j in 1..<views.count{
            //                views[j].backgroundColor = color.dark(brightnessRatio: 1.0)
            //            }
            var color = UIColor()
            var ratio = CGFloat(1.0 - CGFloat(i)*gradation)
            var alpha = CGFloat(CGFloat(i)*gradation)
            for j in 1..<i+1{
//                views[j].backgroundColor = color.dark(brightnessRatio: ratio)
//                views[j].backgroundColor = colors[j].dark(brightnessRatio: ratio)
//                views[j].backgroundColor = views[j].backgroundColor!.dark(brightnessRatio: 1)
                let result_d = realm.object(ofType: Todo.self, forPrimaryKey: String(views[j].tag))
                if(result_d?.datestring == "指定なし"){
                    color = AlldayColor
                }else{
                    color = TaskColor
                }
                views[j].backgroundColor = color.dark(brightnessRatio: ratio)
                //                views[j].backgroundColor = views[j].backgroundColor!.dark(brightnessRatio: ratio)
                for label in views[j].subviews{
                    if type(of: label) ==  UILabel.self {
                        //                        (label as! UILabel).textColor = labelColor.dark(brightnessRatio: ratio)
                    }
                }
                //dark(taskview: views[j], level: alpha)
                //views[j].backgroundColor = views[j].backgroundColor!.dark(brightnessRatio: ratio)
                ratio += gradation
                alpha -= gradation
            }
            ratio = 1.0
            alpha = 0.0
            for j in i+1..<views.count{
//                views[j].backgroundColor = views[j].backgroundColor!.dark(brightnessRatio: 1)
                let result_d = realm.object(ofType: Todo.self, forPrimaryKey: String(views[j].tag))
                if(result_d?.datestring == "指定なし"){
                    color = AlldayColor
                }else{
                    color = TaskColor
                }
                views[j].backgroundColor = color.dark(brightnessRatio: ratio)
//                views[j].backgroundColor = views[j].backgroundColor!.dark(brightnessRatio: ratio)
                for label in views[j].subviews{
                    if type(of: label) ==  UILabel.self {
//                        (label as! UILabel).textColor = labelColor.dark(brightnessRatio: ratio)
                    }
                }
                //dark(taskview: views[j], level: alpha)
                ratio -= gradation
                alpha += gradation
                //views[j].backgroundColor = views[j].backgroundColor!.dark(brightnessRatio: ratio)
            }
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                //薄いViewの大きさを変える
                for view in views[i+1].subviews{
                    
                    if(type(of: view) == UIView.self){
                        //16はタイトルのheiht分
                        view.frame.size.height = size-16
                        for item in view.subviews{
                            if(type(of: item) == UIImageView.self){
                                item.frame.origin.y = view.frame.maxY - item.frame.size.height - 16 - 1 * screen.calScale //時計マーク
                            }
                        }
                        
                    }
                    
                }
                views[i+1].frame.size.height = size
                views[i+1].center = center
                views[i+1].center.x = views[0].frame.minX
                views[i+1].layer.borderColor = UIColor.red.cgColor
                views[i+1].layer.borderWidth = 2
                //選択されたLongPressを有効化
                for gesture in views[i+1].gestureRecognizers! {
                    if type(of: gesture) ==  UILongPressGestureRecognizer.self {
                        gesture.isEnabled = true
                    }
                }
                for j in 1..<i+1{
                    views[j].center.y -= (size - h)/2 //上にずらす
                    //非選択viewのLongPressを無効化
                    for gesture in views[j].gestureRecognizers! {
                        if type(of: gesture) ==  UILongPressGestureRecognizer.self {
                            gesture.isEnabled = false
                        }
                    }
                }
                for j in i+2..<views.count{
                    views[j].center.y += (size - h)/2 //下にずらす
                    //非選択viewのLongPressを無効化
                    for gesture in views[j].gestureRecognizers! {
                        if type(of: gesture) ==  UILongPressGestureRecognizer.self {
                            gesture.isEnabled = false
                        }
                    }
                }
                if(cOs){
                    if(i == 0){
                        scroll.contentOffset.y = 0
                    }else {
                        scroll.contentOffset.y = (border[i] + border[i-1]) / 2
                    }
                }
            }, completion: nil)
            
            break
        }
    }
}

func MoveToRight(scroll:UIScrollView, animation:Bool){
    print("MoveToRight")
    var views = [UIView]()
    for view in scroll.subviews{
        if type(of: view) ==  UIView.self {
            views = view.subviews
        }
    }
    print("views",views[0])
    if(views.count > 1){
        for i in 1 ..< views.count{
            if(views[0].frame.minX > views[i].frame.minX){
                
                let h = views[i].frame.size.height
                let center = views[i].center
                let size = CGFloat(45) * screen.calScale
                let result = realm.object(ofType: Todo.self, forPrimaryKey: String(views[i].tag))
                
                if(animation){ //アニメーションあり
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                        for j in 1..<i{
                            views[j].center.y += (h - size)/2
                        }
                        for j in i+1..<views.count{
                            views[j].center.y -= (h - size)/2
                        }
                        //薄いViewの大きさを変える
                        for view in views[i].subviews{
                            if(type(of: view) == UIView.self){
                                //16はタイトルのheiht分
                                view.frame.size.height = size-16
                                for item in view.subviews{
                                    if(type(of: item) == UIImageView.self){
                                        item.frame.origin.y = view.frame.maxY - item.frame.size.height - 16 - 1 * screen.calScale //時計マーク
                                    }
                                }
                            }
                        }
                        views[i].frame.size.height = size
                        views[i].center = center
                        views[i].frame.origin.x = startPosi * screen.calScale
                        views[i].layer.borderWidth = 0
                        views[i].layer.borderColor = UIColor.black.cgColor
                        views[i].layer.borderWidth = 1
                        for gesture in views[i].gestureRecognizers! {
                            if type(of: gesture) ==  UILongPressGestureRecognizer.self {
                                gesture.isEnabled = false
                            }
                        }
                        
                    }, completion: nil)
                }else{ //アニメーションなし
                    for j in 1..<i{
                        views[j].center.y += (h - size)/2
                    }
                    for j in i+1..<views.count{
                        views[j].center.y -= (h - size)/2
                    }
                    //薄いViewの大きさを変える
                    for view in views[i].subviews{
                        if(type(of: view) == UIView.self){
                            //16はタイトルのheiht分
                            view.frame.size.height = size-16
                            for item in view.subviews{
                                if(type(of: item) == UIImageView.self){
                                    item.frame.origin.y = view.frame.maxY - item.frame.size.height - 16 - 1 * screen.calScale //時計マーク
                                }
                            }
                        }
                    }
                    views[i].frame.size.height = size
                    views[i].center = center
                    views[i].frame.origin.x = startPosi * screen.calScale
                    views[i].layer.borderWidth = 0
                    views[i].layer.borderColor = UIColor.black.cgColor
                    views[i].layer.borderWidth = 1
                    for gesture in views[i].gestureRecognizers! {
                        if type(of: gesture) ==  UILongPressGestureRecognizer.self {
                            gesture.isEnabled = false
                        }
                    }
                    
                }
                break
            }
        }
    }
}

func findBorder(scroll: UIScrollView) -> [CGFloat]{
    var views = [UIView]()
    for view in scroll.subviews{
        if type(of: view) ==  UIView.self {
            views = view.subviews
        }
    }
    var dif = 0
    var border = [CGFloat]()
    if(views.count > 2){
        dif = Int((views[2].center.y - views[1].center.y) / 2)
    }
    for i in 0..<views.count {
        if(i > 0){
            border.append(CGFloat(dif*(i*2-1)))
        }
    }
    return border
}

func dark(taskview: UIView, level:CGFloat) {
    for view in taskview.subviews {
        if type(of: view) ==  UIView.self {
            if(view.backgroundColor == UIColor.black){
                view.alpha = level
            }
        }
    }
}
