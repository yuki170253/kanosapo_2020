//
//  reload.swift
//  MyTodoList
//
//  Created by 三浦 on 2020/09/24.
//  Copyright © 2020 古府侑樹. All rights reserved.
//

import UIKit
import Foundation
import EventKit
import RealmSwift

func reloadLabel(content: UIView){
    print("reloadLabel")
    let calendar = Calendar.current
    let date = Date()
    let hour = calendar.component(.hour, from: date)
    var label = UILabel()
    for i in 0..<24{
        label = content.viewWithTag(i+1) as! UILabel
        label.text = String((hour+i) % 24) + ":00"
        content.addSubview(label)
    }
}

func reloadView(content: UIView){
    let date = Date()
    let hour = calendar.component(.hour, from: date)
    print(hour)
    let firstLabel = (content.viewWithTag(1) as! UILabel).text
    let firstLabel_hour = firstLabel!.components(separatedBy: ":")
    print(firstLabel_hour)
    let dif = (Int(hour) - Int(firstLabel_hour[0])!) * 60
    if(String(firstLabel_hour[0]) != String(hour)){
        print("一時間過ぎた")
        for view in content.subviews{
            if type(of: view) == SampleView.self{
                print(view)
                if(view.frame.origin.y <= CGFloat(30)){
                    view.removeFromSuperview()
                }else{
                    view.frame.origin.y -= CGFloat(dif)
                }
            }
        }
    }else {
        print("一時間過ぎてない")
        for view in content.subviews{
            if(type(of: view) == UILabel.self){
                print(view)
            }
            print("---------")
            if(type(of: view) == SampleView.self){
                for item in view.subviews{
                    if(type(of: item) == UILabel.self){
                        print(item)
                    }
                }
            }
        }
    }
}

func updateViews(content: UIView, allday: UIView){
//    var currentPoint: CGPoint!
    print("updateViews")
//    var c_dotime = Int()
//    var start = Date()
//    var title = String()
//    var color = UIColor()
    let result_d = realm.objects(DefaultCalendar.self)
//    var tagArray = [Int]()
    //今あるViewを削除(MyScrollView)
    for view in content.subviews{
        if(type(of: view) == SampleView.self){
            view.removeFromSuperview()
        }
    }
    //今あるViewを削除(AlldayView)
    for view in allday.subviews{
        if(type(of: view) == UIView.self){
            view.removeFromSuperview()
        }
    }
    //DefaultCalendarからスケジュールを作成
    for item in result_d{
            let color = UIColor(displayP3Red: CGFloat(item.color_r), green: CGFloat(item.color_g), blue: CGFloat(item.color_b), alpha: 1.0)
            let add_view = makeView(id: item.calendarid, title: item.title, color: color)
            content.addSubview(add_view)
    }
    craftCalendar(base_view: content)
//    for view in content.subviews{
//        if(realm.object(ofType: DefaultCalendar.self, forPrimaryKey: String(view.tag)) != nil){
//            if(view.tag >= 1000000000 && view.tag < 10000000000){ //Todo
//                let result = realm.object(ofType: Calendar24.self, forPrimaryKey: String(view.tag))!
//                c_dotime = result.c_dotime
//                start = result.start
//            }else if(view.tag > 10000000000 && view.tag <= 100000000000){//DefaultCalendar
//                let result = realm.object(ofType: DefaultCalendar.self, forPrimaryKey: String(view.tag))
//                if(result == nil){
//                    view.removeFromSuperview()
//                    continue
//                }else{
//                    c_dotime = result!.c_dotime
//                    start = result!.start
//                    title = result!.title
//                    color = UIColor(displayP3Red: CGFloat(result!.color_r), green: CGFloat(result!.color_g), blue: CGFloat(result!.color_b), alpha: 1.0)
//                }
//            }
//            let now = Date()
//            let no1point = 30
//            let no23point = 1410
//            let hour = (no23point - no1point)/23
//            let minute:Double
//            minute = Double(hour)/Double(60)
//            let end = Calendar.current.date(byAdding: .second, value: c_dotime, to: start)!
//            let diffNow = Calendar.current.dateComponents([.minute], from: now as Date, to: start).minute!
//            let diffMin = Calendar.current.dateComponents([.minute], from:  start, to: end).minute!
//            var y = CGFloat(Double(no1point) + minute * Double(diffNow) + Double(Calendar.current.component(.minute, from: now)) * minute)
//            for i in 0..<92 {
//                if(Double(y) > Double(no1point) + Double(hour*i/4) && Double(y) <= Double(no1point) + Double(hour/8) + Double(hour*i/4)){
//                    y = CGFloat(Double(no1point) + Double(hour*i/4))
//                }else if(Double(y) <= Double(no1point) + Double(hour*(i+1)/4) && Double(y) > Double(no1point) + Double(hour/8) + Double(hour*i/4)){
//                    y = CGFloat(Double(no1point) + Double(hour*(i+1)/4))
//                }
//            }
//            if(currentPoint != nil){
//                y += currentPoint.y
//            }
//            let frame:CGRect = CGRect(x: 60, y: y, width: 300, height: CGFloat(minute * Double(diffMin)) + 20)
//            view.frame = frame
//
//            for label in view.subviews {
//                if(type(of: label) == UILabel.self) {
//                    if(label.frame.minY == 0){
//                        (label as! UILabel).text = title
//                        (label as! UILabel).backgroundColor = color
//                    }
//
//                }
//            }
//            (view as! SampleView).content.frame = CGRect(x: 0, y: 0, width: 300, height: CGFloat(minute * Double(diffMin)))
//            (view as! SampleView).content.backgroundColor = color
//            (view as! SampleView).fakeView.backgroundColor = color
//            (view as! SampleView).leftBorder.frame.size.height = CGFloat(minute * Double(diffMin))
//            (view as! SampleView).leftBorder.backgroundColor = color
//            (view as! SampleView).title.text = title
//            (view as! SampleView).title.backgroundColor = color
//            (view as! SampleView).circle.center.y = CGFloat(minute * Double(diffMin))
//
//            tagArray.append(view.tag)
//        }
//    }
//    print("~~~~~")
//    for cal in result_d{
//        for tag in tagArray{
//            print(cal.calendarid)
//            print(tag)
//            if(realm.object(ofType: DefaultCalendar.self, forPrimaryKey: String(tag)) == nil){
//                print("新しく追加")
//                let color = UIColor(displayP3Red: CGFloat(cal.color_r), green: CGFloat(cal.color_g), blue: CGFloat(cal.color_b), alpha: 1.0)
//                let add_view = makeView(id: cal.calendarid, title: cal.title, color: color)
//                content.addSubview(add_view)
//            }
//        }
//    }
}

