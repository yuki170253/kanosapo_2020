//
//  craftCalendr.swift
//  MyTodoList
//
//  Created by 三浦 on 2020/09/23.
//  Copyright © 2020 古府侑樹. All rights reserved.
//

import UIKit
import Foundation

import EventKit
import RealmSwift

func deleteViews(content: UIView, allday: UIView, menu: UIView){
        for view in content.subviews{
            if type(of: view) == SampleView.self {
                view.removeFromSuperview()
            }
        }
        for view in allday.subviews{
            if(type(of: view) == UIView.self){
                view.removeFromSuperview()
            }
        }
        for view in menu.subviews{
            if type(of: view) == UIView.self {
                view.removeFromSuperview()
            }
        }
    }
    //
    var centerPoint = CGPoint()
    var scrollFlag = false
    var moveView1 = CGPoint()
    var moveView2 = CGPoint()
    let topBorder = CALayer()

    var location = CGPoint(x: 0, y: 0)
    var aTouch = UITouch()
    var sTouch = CGPoint(x: 0, y: 0)
    var userY = CGFloat()
    var dummyAllFlag = false

    var autoScrollTimer = Timer()
    var View = ViewController()

    func craftCalendar(base_view: UIView){
        print("craftCalendar")
        
        let no1point = 30
        let no23point = 1410
        let hour = (no23point - no1point)/23
        let minute:Double
        minute = Double(hour)/Double(60)
        
        let cal = realm.objects(Calendar24.self)
        let defaultcal = realm.objects(DefaultCalendar.self)
        
        for item in cal {
            let color = UIColor.black
            let add_view = makeView(id: item.calendarid, title: item.todo.first!.title, color: color)
            base_view.addSubview(add_view)
        }
        print("DefaultCalendar")
        for item in defaultcal {
            if(item.allDay == false){
                let color = UIColor(displayP3Red: CGFloat(item.color_r), green: CGFloat(item.color_g), blue: CGFloat(item.color_b), alpha: 1.0)
                let add_view = makeView(id: item.calendarid, title: item.title, color: color)
                base_view.addSubview(add_view)
            }
        }
    }

    //    終日作成
    func craftAllday(base_view: UIView) {
        var cnt = 0
        print("craftAllday")
        var y = Int(-1)
        let d_cal = realm.objects(DefaultCalendar.self)
        for item in d_cal{
            if(item.allDay){
                if(cnt % 4 == 0){
                    cnt = 0
                    y += 1
                }
                print("craftAll")
                let width = 80
                let height = 20
                let x = 85
                let y = 24
                let frame = CGRect(x: 5 + (cnt * 85), y: 3 + (y * 24), width: 80, height: 20)
                let TestView = makeTaskView(frame: frame, tag: Int(item.calendarid)!, title: item.title)
                base_view.addSubview(TestView)
                cnt += 1
            }
        }
    }

    func craftManu(stamp: UIView, target: UIView){
        print("craftManu")
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .full
        f.locale = Locale(identifier: "ja_JP")
        let Now = NSDate() as Date
        let date = f.string(from: Now)
        
        let x = 5
        let y = 25
        let width = -10
        let height = 20
        
        let result_m = realm.objects(Todo.self).filter("datestring == '指定なし'")
        let result_s = realm.objects(Todo.self).filter("datestring == %@", date)
        for item in result_m{
            let frame = CGRect(x: 5, y: 5 + ((stamp.subviews.count) * 25), width: Int(target.frame.size.width) - 10, height: 20)
            let TestView = makeTaskView(frame: frame, tag: Int(item.todoid)!, title: item.title)
            stamp.addSubview(TestView)
        }
        print("タスクView作成")
        for item in result_s{
            print(item.base)
            if(item.base != ""){
                continue
            }
            let frame = CGRect(x: 5, y: 5 + ((target.subviews.count) * 25), width: Int(target.frame.size.width) - 10, height: 20)
            let TestView = makeTaskView(frame: frame, tag: Int(item.todoid)!, title: item.title)
            target.addSubview(TestView)
        }
    }



