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
}

