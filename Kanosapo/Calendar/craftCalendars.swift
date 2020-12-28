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
    
    let no1point = ScreenSize().no1point
    let no23point = ScreenSize().no23point
    let hour = (no23point - no1point)/23
    let minute:Double
    minute = Double(hour)/Double(60)
    
    let cal = realm.objects(Calendar24.self).filter("todoDone==false")
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
