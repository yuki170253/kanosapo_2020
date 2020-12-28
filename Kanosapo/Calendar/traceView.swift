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








func traceView(userY: CGFloat, height: CGFloat, tag: Int, content: UIView) -> Int{
    print("traceView")
    
    let x:CGFloat = 60
    var y:CGFloat = userY
    if(currentPoint != nil){
        y += currentPoint.y
    }
    
    print("startTime-traceView")
    let startTime = getTaskTime(y: userY)
    let search_datestring = getTaskTime(y: userY)
    var new_todoID : Int = 0
    let new_todo = Todo()
    var save_id = String()
    
    let f = DateFormatter()
    f.timeStyle = .none
    f.dateStyle = .full
    f.locale = Locale(identifier: "ja_JP")
    
    var flag = false
    save_id = String(tag)
    
    if(tag > 1000000000 && tag <= 10000000000){ //calendar24
        let result_t = realm.object(ofType: Todo.self, forPrimaryKey: String(tag))!
        let base_results = realm.objects(Todo.self).filter("base==%@", result_t.todoid)
        if(base_results.count > 0){
            flag = true
        }
        if(base_results.count >= 2){
            for item in base_results{
                if(f.string(from: search_datestring) == item.datestring){   //座標から日付を取得
                    try! realm.write {
                        if(flag == true){
                            let cal = Calendar24()
                            let new_cal = realm.object(ofType: Todo.self, forPrimaryKey: item.todoid)
                            cal.calendarid = randomString(length: 10)
                            cal.todoDone = false
                            cal.start = startTime
                            cal.default_allday = false
                            cal.c_dotime = result_t.dotime
                            cal.end = Calendar.current.date(byAdding: .second, value: result_t.dotime, to: startTime)!
                            new_cal?.InFlag = true
                            new_cal!.calendars.append(cal)
                            let add_view = makeView(id: cal.calendarid, title: result_t.title, color: UIColor.black)
                            content.addSubview(add_view)
                        }
                    }
                }
            }
        }else{
            if(f.string(from: search_datestring) == base_results.first?.datestring){   //座標から日付を取得
                try! realm.write {
                    if(flag == true){
                        let cal = Calendar24()
                        let new_cal = realm.object(ofType: Todo.self, forPrimaryKey: base_results.first!.todoid)
                        cal.calendarid = randomString(length: 10)
                        cal.todoDone = false
                        cal.start = startTime
                        cal.default_allday = false
                        cal.c_dotime = result_t.dotime
                        cal.end = Calendar.current.date(byAdding: .second, value: result_t.dotime, to: startTime)!
                        new_cal?.InFlag = true
                        new_cal!.calendars.append(cal)
                        let add_view = makeView(id: cal.calendarid, title: result_t.title, color: UIColor.black)
                        content.addSubview(add_view)
                    }
                }
            }else{
                try! realm.write {
                    if(result_t.datestring == "指定なし"){
                        new_todo.todoid = randomString(length: 10)
                        save_id = new_todo.todoid
                        new_todoID = Int(new_todo.todoid)!
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
                    cal.end = Calendar.current.date(byAdding: .second, value: result_t.dotime, to: startTime)!
                    new_cal?.InFlag = true
                    new_cal!.calendars.append(cal)
                    let add_view = makeView(id: cal.calendarid, title: result_t.title, color: UIColor.black)
                    content.addSubview(add_view)
                }
            }
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
    
    
    
    
    //    if(tag > 1000000000 && tag <= 10000000000){ //calendar24
    //        let result_t = realm.object(ofType: Todo.self, forPrimaryKey: String(tag))!
    //
    //        print("~~~~~~result_t~~~~~~~")
    //        let f = DateFormatter()
    //        f.timeStyle = .none
    //        f.dateStyle = .full
    //        f.locale = Locale(identifier: "ja_JP")
    //        save_id = String(tag)
    //        try! realm.write {
    //            if(result_t.datestring == "指定なし"){
    //                new_todo.todoid = randomString(length: 10)
    //                save_id = new_todo.todoid
    //                new_todoID = Int(new_todo.todoid)!
    //                new_todo.title = String(result_t.title)
    //                new_todo.todoDone = false
    //                new_todo.donetime = 0
    //                new_todo.dotime = result_t.dotime
    //                new_todo.date = startTime
    //
    //                new_todo.datestring = f.string(from: startTime)
    //
    //                new_todo.InFlag = true
    //                new_todo.base = result_t.todoid
    //                realm.add(new_todo)
    //            }
    //
    //            let cal = Calendar24()
    //            let new_cal = realm.object(ofType: Todo.self, forPrimaryKey: save_id)
    //            cal.calendarid = randomString(length: 10)
    //            cal.todoDone = false
    //            cal.start = startTime
    //            cal.default_allday = false
    //            cal.c_dotime = result_t.dotime
    //            cal.end = Calendar.current.date(byAdding: .second, value: result_t.dotime, to: startTime)!
    //            new_cal?.InFlag = true
    //            new_cal!.calendars.append(cal)
    //            let add_view = makeView(id: cal.calendarid, title: result_t.title, color: UIColor.black)
    //            content.addSubview(add_view)
    //        }
    //
    //    }else if(tag > 10000000000 && tag <= 100000000000){ //default
    //        let result_d = realm.object(ofType: DefaultCalendar.self, forPrimaryKey: String(tag))!
    //        print("~~~~~~~~^result_d~~~~~~~~")
    //        print(result_d)
    //        try! realm.write {
    //            result_d.allDay = false
    //            result_d.start = startTime
    //        }
    //        let color = UIColor(displayP3Red: CGFloat(result_d.color_r), green: CGFloat(result_d.color_g), blue: CGFloat(result_d.color_b), alpha: 1.0)
    //        let add_view = makeView(id: result_d.calendarid, title: result_d.title, color: color)
    //        content.addSubview(add_view)
    //        //かける追加 12/4
    //        //追加したViewが標準カレンダーの終日のスケジュールだった場合addEventをする
    //
    //        test_userDefaultData(view: add_view)
    //        new_addEvent(tag: add_view.tag)
    //    }
    print("traceView終了")
    
    //0ではない場合
    //指定ありのタスクで、新しくTodoへ追加される
    //元のタスクのtagを新しいtodoIDへ変更する
    return new_todoID
}
