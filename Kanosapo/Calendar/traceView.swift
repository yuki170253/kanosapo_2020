//
//  traceView.swift
//  MyTodoList
//
//  Created by 三浦 on 2020/09/24.
//  Copyright © 2020 古府侑樹. All rights reserved.
//

import UIKit
import Foundation

import EventKit
import RealmSwift

var currentPoint: CGPoint!


func traceView(userY: CGFloat, height: CGFloat, tag: Int, content: UIView, ReturnButton: UIButton){
    print("traceView")
    
    let x:CGFloat = 60
    var y:CGFloat = userY
    if(currentPoint != nil){
        y += currentPoint.y
    }
    
    print("startTime-traceView")
    let startTime = getTaskTime(y: userY)
    
    let new_todo = Todo()
    var save_id = String()
    if(tag > 1000000000 && tag <= 10000000000){ //calendar24
        let result_t = realm.object(ofType: Todo.self, forPrimaryKey: String(tag))!
        let f = DateFormatter()
        print("~~~~~~result_t~~~~~~~")
        f.timeStyle = .none
        f.dateStyle = .full
        f.locale = Locale(identifier: "ja_JP")
        save_id = String(tag)
        try! realm.write {
            if(result_t.datestring == "指定なし"){
                new_todo.todoid = randomString(length: 10)
                save_id = new_todo.todoid
                new_todo.title = String(result_t.title)
                new_todo.todoDone = false
                new_todo.donetime = 0
                new_todo.dotime = result_t.dotime
                new_todo.date = startTime
                new_todo.datestring = f.string(from: startTime)
                new_todo.InFlag = true
                new_todo.base = result_t.todoid
                realm.add(new_todo)
            }
            
            let cal = Calendar24()
            let new_cal = realm.object(ofType: Todo.self, forPrimaryKey: save_id)
            cal.calendarid = randomString(length: 10)
            cal.todoDone = false
            cal.start = startTime
            cal.default_allday = false
            cal.c_dotime = result_t.dotime
            new_cal?.InFlag = true
            new_cal!.calendars.append(cal)
            let add_view = makeView(id: cal.calendarid, title: result_t.title, color: UIColor.black)
            content.addSubview(add_view)
        }
        
    }else if(tag > 10000000000 && tag <= 100000000000){ //default
        let result_d = realm.object(ofType: DefaultCalendar.self, forPrimaryKey: String(tag))!
        print("~~~~~~~~^result_d~~~~~~~~")
        print(result_d)
        try! realm.write {
            result_d.allDay = false
            result_d.start = startTime
        }
        let color = UIColor(displayP3Red: CGFloat(result_d.color_r), green: CGFloat(result_d.color_g), blue: CGFloat(result_d.color_b), alpha: 1.0)
        let add_view = makeView(id: result_d.calendarid, title: result_d.title, color: color)
        content.addSubview(add_view)
        //かける追加 12/4
        //追加したViewが標準カレンダーの終日のスケジュールだった場合addEventをする
        
        test_userDefaultData(view: add_view)
        new_addEvent(tag: add_view.tag)
    }
    print("traceView終了")
}
