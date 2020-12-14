//
//  userDefaultData.swift
//  MyTodoList
//
//  Created by 三浦 on 2020/09/24.
//  Copyright © 2020 古府侑樹. All rights reserved.
//
import UIKit
import Foundation
import EventKit
import RealmSwift



func userDefaultData(content: UIView){
    print("userDefaultData")
    
    
    
    let dateFormater = DateFormatter()
    
    dateFormater.locale = Locale(identifier: "ja_JP")
    dateFormater.dateFormat = "yyyy/MM/dd"
    dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
    print("userDefaultData-Content.subviews")
    
    for view in content.subviews{
        if(type(of: view) == SampleView.self){
            print(view.tag)
            let startTime = getTaskTime(y: view.frame.origin.y)
            let dotime = Int((view.frame.height-20) * 60)
//            let end = convert_string_details(date: Calendar.current.date(byAdding: .second, value: dotime, to: startTime)!)
            if(view.tag > 1000000000 && view.tag < 10000000000){ //calendar24
                try! realm.write{
                    let day = startTime
                    let end = Calendar.current.date(byAdding: .second, value: dotime, to: day)!
                    let item = realm.object(ofType: Calendar24.self, forPrimaryKey: String(view.tag))
                    item!.start = startTime
                    item!.c_dotime = dotime
                    item!.end = end
                }
            }else if(view.tag >= 10000000000){ //default
                try! realm.write{
                    let day = startTime
                    let end = Calendar.current.date(byAdding: .second, value: dotime, to: day)!
                    let item = realm.object(ofType: DefaultCalendar.self, forPrimaryKey: String(view.tag))
                    item!.start = startTime
                    item!.c_dotime = dotime
                    item!.end = end

                    print(startTime)
                    print(end)
                }
            }
        }
    }
}

func test_userDefaultData(view: UIView){
    print("userDefaultData")
    let dateFormater = DateFormatter()
    dateFormater.locale = Locale(identifier: "ja_JP")
    dateFormater.dateFormat = "yyyy/MM/dd"
    dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
    print("userDefaultData-Content.subviews")
    let startTime = getTaskTime(y: view.frame.origin.y)
    let dotime = Int((view.frame.height-20) * 60)
    if(view.tag > 1000000000 && view.tag < 10000000000){ //calendar24
        try! realm.write{
            let day = startTime
            let end = Calendar.current.date(byAdding: .second, value: dotime, to: day)!
            let item = realm.object(ofType: Calendar24.self, forPrimaryKey: String(view.tag))
            item!.start = startTime
            item!.c_dotime = dotime
            item!.end = end
        }
    }else if(view.tag >= 10000000000){ //default
        try! realm.write{
            let day = startTime
            let end = Calendar.current.date(byAdding: .second, value: dotime, to: day)!
            let item = realm.object(ofType: DefaultCalendar.self, forPrimaryKey: String(view.tag))
            item!.start = startTime
            item!.c_dotime = dotime
            item!.end = end
        }
    }
}
