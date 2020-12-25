//
//  makeView.swift
//  MyTodoList
//
//  Created by 三浦 on 2020/09/23.
//  Copyright © 2020 古府侑樹. All rights reserved.
//
import UIKit
import Foundation

import EventKit
import RealmSwift

//, button: UIButton

func makeView(id:String, title:String, color:UIColor) -> SampleView{
    
    var currentPoint: CGPoint!
    let button = ViewController().makeButton()
    let screen = ScreenSize()
    /*
     start 開始時間
     c_dotime タスク幅
     dotime 目標時間
     title タイトル
     color 色
     */
    print("makeView")
    var c_dotime = Int()
    var start = Date()
    if(Int(id)! > 1000000000 && Int(id)! <= 10000000000){ //calendar24
        print("calendar")
        let result = realm.object(ofType: Calendar24.self, forPrimaryKey: id)!
        c_dotime = result.c_dotime
        start = result.start
    }else if(Int(id)! > 10000000000 && Int(id)! <= 100000000000){ //default
        print("default")
        let result = realm.object(ofType: DefaultCalendar.self, forPrimaryKey: id)!
        c_dotime = result.c_dotime
        start = result.start
    }
    let now = Date()
    let no1point = screen.no1point
    let no23point = screen.no23point
    let hour = (no23point - no1point)/23
    let minute:Double
    minute = Double(hour)/Double(60)
    let end = Calendar.current.date(byAdding: .second, value: c_dotime, to: start)!
    let diffNow = Calendar.current.dateComponents([.minute], from: now as Date, to: start).minute!
    let diffMin = Calendar.current.dateComponents([.minute], from:  start, to: end).minute!
    var y = CGFloat(Double(no1point) + minute * Double(diffNow) + Double(Calendar.current.component(.minute, from: now)) * minute)
    for i in 0..<92 {
        if(Double(y) > Double(no1point) + Double(hour*i/4) && Double(y) <= Double(no1point) + Double(hour/8) + Double(hour*i/4)){
            y = CGFloat(Double(no1point) + Double(hour*i/4))
        }else if(Double(y) <= Double(no1point) + Double(hour*(i+1)/4) && Double(y) > Double(no1point) + Double(hour/8) + Double(hour*i/4)){
            y = CGFloat(Double(no1point) + Double(hour*(i+1)/4))
        }
    }
    if(currentPoint != nil){
        y += currentPoint.y
    }
    let frame:CGRect = CGRect(x: 60, y: y, width: screen.screenWidth - 15 - 60, height: CGFloat(minute * Double(diffMin) + 20 * minute))
    let calendarView:SampleView = SampleView(frame: frame)
    calendarView.content.backgroundColor = color
    calendarView.leftBorder.backgroundColor = color
    calendarView.fakeView.backgroundColor = color
    calendarView.title.backgroundColor = color
    
    let titleLabel: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: calendarView.frame.width,height: 15))
    //titleLabel.text = "  " + item.todo.first!.title
    titleLabel.text = title
    titleLabel.textColor = UIColor.white
    titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
    titleLabel.layer.masksToBounds = true
    titleLabel.layer.cornerRadius = 4
    titleLabel.backgroundColor = color
    
    let tasktime = c_dotime/60
    let tasktimeLabel: UILabel = UILabel(frame: CGRect(x: 100,y: 20,width: 100,height: 20))
    let timetext = String(format: "%02dh %02dm", Int(tasktime/60), Int(round(Double(tasktime) - Double(60*Int(tasktime/60)))))
    tasktimeLabel.text = timetext
    tasktimeLabel.textColor = UIColor.white
    var imageView = UIImageView(image:UIImage(named:"x")!)
    calendarView.addSubview(titleLabel)
    calendarView.addSubview(button)
    calendarView.tag = Int(id)!
    
    return calendarView
}

func makeTaskView(frame: CGRect, tag: Int, title: String) -> UIView{
    let TaskView = UIView()
    let ContentView = UIView()
    let width = frame.width
    let height = frame.height
    TaskView.frame = frame
    ContentView.frame = CGRect(x: 0, y: 16, width: width, height: height-16)
    print(tag)
    TaskView.tag = tag
    let taskTitle: UILabel = UILabel(frame: CGRect(x: 5,y: 1,width: TaskView.frame.size.width-5,height: 15))
    taskTitle.text = title
    taskTitle.textColor = UIColor.black
    //フォントサイズ
    TaskView.layer.cornerRadius = 2
//    taskTitle.textAlignment = NSTextAlignment.center
    taskTitle.textAlignment = NSTextAlignment.left
    taskTitle.font = UIFont(name: "Tsukushi A Round Gothic", size: 12)
    var color = UIColor.white
//    if(tag > 10000000000 && tag <= 100000000000){ //defaultCalendar
//        let result = realm.object(ofType: DefaultCalendar.self, forPrimaryKey: String(tag))!
//        color = UIColor(displayP3Red: CGFloat(result.color_r), green: CGFloat(result.color_g), blue: CGFloat(result.color_b), alpha: 1.0)
//    }
//    TaskView.backgroundColor = UIColor.clear
    ContentView.backgroundColor = color
    ContentView.alpha = 0.3
    TaskView.addSubview(taskTitle)
    TaskView.addSubview(ContentView)
    return TaskView
}
