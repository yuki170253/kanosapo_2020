////
////  getData.swift
////  MyTodoList
////
////  Created by 三浦 on 2020/09/03.
////  Copyright © 2020 古府侑樹. All rights reserved.
////

import UIKit

import EventKit
import RealmSwift
import Foundation




let calendar = Calendar.current
var calendars = [EKCalendar]()
var eventArray = [EKEvent]()

let eventStore = EKEventStore()
//let calendarItem = EKCalendarItem()


func checkAuth(){
    print("checkAuth")
    let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
    if status == .authorized { // もし権限がすでにあったら
        print("アクセスできます！！")
    }else if status == .notDetermined {
        // アクセス権限のアラートを送る。
        eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
            if granted { // 許可されたら
                print("アクセス可能になりました。")
            }else { // 拒否されたら
                print("アクセスが拒否されました。")
            }
        }
    }
}

var EventData = [CalendarData]()
var Dic: [String: String] = [:]
var Dic_c: [String: String] = [:]
func makeDictionary(){
    print("makeDictionary")
    //DicとEventDataを初期化
    Dic.removeAll()
    EventData.removeAll()
    //calendaridとeventIdentifierをつなぎ合わせた辞書を作成(キーはeventIdentifier)
    //calendaridと対応したEKEventを格納するEventDataを作成
    let d_cal = realm.objects(DefaultCalendar.self)
    for item in d_cal{
        Dic.updateValue(item.calendarid, forKey: item.event)
        Dic_c.updateValue(item.event, forKey: item.calendarid)
        let event = eventStore.event(withIdentifier: item.event)
        if(event != nil){
            EventData.append(CalendarData(eventid: item.event, calendarid: item.calendarid, event: event!))
        }
    }
    print(Dic)
    print(Dic_c)
}

func searchEventData(calendarid: String)-> EKEvent{
    print("searchEventData")
    let d_cal = realm.objects(DefaultCalendar.self)
    var cnt = 0
    var result = EKEvent()
    for item in d_cal{
        print(item.calendarid)
        print(EventData[cnt])
        if(item.calendarid == EventData[cnt].CalendarID){
            result = EventData[cnt].Event
        }
        cnt += 1
    }
    print(result)
    return result
}

func test(){
    for event in eventArray{
        print(type(of: event.title))//String
        print(type(of: event.location))//String
        print(type(of: event.calendar))//EKCalendar
        print(type(of: event.alarms))//EKAlarms
        print(type(of: event.url))//URL?
    }
}


//EnterForegroundで呼ばれるgetCalendar
//addEventにて追加した新Eventのidentifierと対応するrealmデータを更新する
func test_getCalendar(){
    print("test_getCalendar")
    makeDictionary()
    var componentsOneDayDelay = DateComponents()
    componentsOneDayDelay.hour = 24 // 今の時刻から1年進めるので1を代入
    let startDate = Date()
    let endDate = calendar.date(byAdding: componentsOneDayDelay, to: Date())!
    let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
    eventArray = eventStore.events(matching: predicate)
    calendars = eventStore.calendars(for: .event)
    let reminder = EKReminder(eventStore: eventStore)
    let calendars = eventStore.calendars(for: .reminder)
//    for cal in calendars{
//        print(cal)
//    }
    for event in eventArray{
        print(Dic)
        print(event.eventIdentifier)
        let cal_id = Dic[event.eventIdentifier]
        print(cal_id)
        //新規calendarのcalendarid用
        var cnt = 0
        if(cal_id != nil){
            print("もともとある")
            let result_d = realm.object(ofType: DefaultCalendar.self, forPrimaryKey: cal_id)!
            let getEvent = eventStore.event(withIdentifier: result_d.event)!
            try! realm.write{
                result_d.title = getEvent.title
                result_d.start = getEvent.startDate
                result_d.end = getEvent.endDate
                result_d.allDay = getEvent.isAllDay
                let diffMin = Calendar.current.dateComponents([.minute], from:  result_d.start, to: result_d.end).minute!
                if(result_d.allDay){
                    result_d.c_dotime = 3600
                }else{
                    result_d.c_dotime = diffMin * 60
                }
                result_d.color_r = Double(round(getEvent.calendar.cgColor.components![0]*100)/100)
                result_d.color_g = Double(round(getEvent.calendar.cgColor.components![1]*100)/100)
                result_d.color_b = Double(round(getEvent.calendar.cgColor.components![2]*100)/100)
                result_d.calendar = getEvent.calendar.calendarIdentifier
                print(result_d)
                print("--------")
            }
        }else{//標準カレンダー側で新規追加されたイベント
            print("新規")
            let new_cal = DefaultCalendar()
            try! realm.write{
                if(cnt >= 9){
                    new_cal.calendarid = randomString(length: 9) + String(cnt + 1)
                }else{
                    new_cal.calendarid = randomString(length: 9) + "0" + String(cnt + 1)
                }
                new_cal.title = event.title
                new_cal.start = event.startDate
                new_cal.end = event.endDate
                new_cal.allDay = event.isAllDay
                let diffMin = Calendar.current.dateComponents([.minute], from:  new_cal.start, to: new_cal.end).minute!
                if(new_cal.allDay){
                    new_cal.c_dotime = 3600
                }else{
                    new_cal.c_dotime = diffMin * 60
                }
                new_cal.color_r = Double(round(event.calendar.cgColor.components![0]*100)/100)
                new_cal.color_g = Double(round(event.calendar.cgColor.components![1]*100)/100)
                new_cal.color_b = Double(round(event.calendar.cgColor.components![2]*100)/100)
                new_cal.calendar = event.calendar.calendarIdentifier
                //カケル　追加 10/24
                new_cal.event = event.eventIdentifier
                realm.add(new_cal)
                print(new_cal)
                print("--------")
            }
            cnt += 1
        }
    }
    //標準カレンダー側でスケジュールが削除された場合realmから削除
    let d_cal = realm.objects(DefaultCalendar.self)
    for cal in d_cal{
        let event = eventStore.event(withIdentifier: cal.event)
        if(event == nil){
            try! realm.write{
                realm.delete(cal)
            }
        }
    }
}

func test_addEvent(){
    print("test_addEvent")
    var eventArray2 = [EKEvent]()
    let d_cal = realm.objects(DefaultCalendar.self)
//    var calendarItem = EKCalendarItem()
    for item in d_cal{
        let event = eventStore.event(withIdentifier: item.event)!
        let calendarItem = eventStore.calendarItem(withIdentifier: event.calendarItemIdentifier)!
        let new_event = EKEvent(eventStore: eventStore)
        //        let new_event = eventStore.event(withIdentifier: item.event)!
        
        //かのサポ内で利用する情報の上書き
//        for i in 0..<calendars.count{
//            if(item.calendar == calendars[i].calendarIdentifier){
//                new_event.calendar = calendars[i]
//
//            }
//        }
        //calendarItemで追加
//        calendarItem.calendar = eventStore.calendar(withIdentifier: item.calendar)
        //EKeventで追加
        new_event.title = item.title
        new_event.location = event.location //かのサポでは使わない
        new_event.calendar = eventStore.calendar(withIdentifier: item.calendar)
        new_event.alarms = event.alarms //かのサポでは使わない
        new_event.url = event.url //かのサポでは使わない
        new_event.startDate = item.start
        new_event.endDate = item.end
        new_event.isAllDay = item.allDay
//        //かのサポ内で利用しない情報を新しいイベントにコピー
        new_event.recurrenceRules = event.recurrenceRules
        new_event.notes = event.notes
        
//        new_event.attendees = []
//        new_event.lastModifiedDate = item.start
//        new_event.structuredLocation = EKStructuredLocation
//
//        new_event.floating
//        new_event.travelTime
//        new_event.startLocation
        
//        new_event.attendees = event.attendees  //getで書かなければいけない
        //        new_event.travelTime  EKEventにtravelTimeがいない
        //        new_event.startLocation  EKEventにstartLocationがいない
        eventArray2.append(new_event)
//        do {
////            try eventStore.save(calendarItem as! EKEvent, span: .thisEvent, commit: true)
//            try eventStore.save(new_event, span: .thisEvent, commit: true)
////            try eventStore.save(calendarItem as! EKReminder, commit: true)
//        } catch let error{
//            print("同期失敗")
//            print(error)
//        }
    }
    
    //2重ループ　DefaultCalendarのプライマリーキーをeventStore.identifierにすれば解決できそう
    print("----登録----")
    for cal in d_cal{
        for event in eventArray2{
            if(event.title == cal.title){ //とりあえずtitleで識別
                print(event)
                print(type(of:event))
                do {
                    try eventStore.save(event, span: .thisEvent, commit: true)
                    try eventStore.saveCalendar(event.calendar, commit: true)
//                    try eventStore.save(calendarItem as! EKReminder, commit: true)
                    //追加したeventの識別子をDefaultCalendarに格納
                    //この値を使ってnext_getCalendarで標準カレンダーの変更分を更新する
                    try! realm.write{
                        cal.event = event.eventIdentifier
                    }
                    print("-----~~~~~~~")
                } catch let error {
                    print("同期失敗")
                    print(error)
                }
            }else{
                print("見つかりませんでした")
            }
        }
    }
    print("----削除----")
    for item in eventArray{
        do {
            try eventStore.remove(item, span: .thisEvent)
            print(item)
        } catch let error {
            print("削除失敗")
            print(error)
        }
    }
    print(Dic)
}

func getCalendar(){
    print("getCalendar")
    //残ってるrealmを全削除
    try! realm.write{
        let results = realm.objects(DefaultCalendar.self)
        realm.delete(results)
    }
    
    var componentsOneDayDelay = DateComponents()
    componentsOneDayDelay.hour = 24 // 今の時刻から1年進めるので1を代入
    let startDate = Date()
    let endDate = calendar.date(byAdding: componentsOneDayDelay, to: Date())!
    
    let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
    
    eventArray = eventStore.events(matching: predicate)
    calendars = eventStore.calendars(for: .event)
    var cnt = 0
    print("getCalendar_realm.write")
    for event in eventArray{
        print(type(of: event))
        try! realm.write{
            let item = DefaultCalendar()
            
            item.title = event.title
            item.start = event.startDate
            item.end = event.endDate
            if(cnt >= 9){
                item.calendarid = randomString(length: 9) + String(cnt + 1)
            }else{
                item.calendarid = randomString(length: 9) + "0" + String(cnt + 1)
            }
            let diffMin = Calendar.current.dateComponents([.minute], from:  item.start, to: item.end).minute!
            item.allDay = event.isAllDay
            if(event.isAllDay){
                item.c_dotime = 3600
            }else{
                item.c_dotime = diffMin * 60
            }
            item.color_r = Double(round(event.calendar.cgColor.components![0]*100)/100)
            item.color_g = Double(round(event.calendar.cgColor.components![1]*100)/100)
            item.color_b = Double(round(event.calendar.cgColor.components![2]*100)/100)
            item.calendar = event.calendar.title
            //カケル　追加 10/23
            item.event = event.eventIdentifier
            print(item)
            print("~~~~~")
            realm.add(item)
        }
        cnt += 1
    }
    makeDictionary()
}


//func addEvent() {
//    print("addEvent")
//    // イベントの情報を準備
//    var componentsOneDayDelay = DateComponents()
//    componentsOneDayDelay.hour = 24 // 今の時刻から1年進めるので1を代入
//    var eventArray2 = [EKEvent]()
//    let date = NSDate() as Date
//    let dateFormater = DateFormatter()
//
//    dateFormater.locale = Locale(identifier: "ja_JP")
//    dateFormater.dateFormat = "yyyy/MM/dd"
//    dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
//
//    let d_cal = realm.objects(DefaultCalendar.self)
//    let defaultCalendar = eventStore.defaultCalendarForNewEvents
//
//    for item in d_cal{
//        let event = EKEvent(eventStore: eventStore)
//        for i in 0..<calendars.count{
//            print("~~~~~~~~~")
//            if(item.calendar == calendars[i].title){
//                event.calendar = calendars[i]
//                print(item.calendar)
//                print(calendars[i])
//            }
//        }
//
//        event.title = item.title
//        event.startDate = item.start
//        event.endDate = item.end
//        event.isAllDay = item.allDay
//
//        eventArray2.append(event)
//    }
//
//    print(eventArray2)
//    print("----削除----")
//    //    for item in eventArray{
//    //        do {
//    //            try eventStore.remove(item, span: .thisEvent)
//    //        } catch let error {
//    //            print("削除失敗")
//    //            print(error)
//    //        }
//    //    }
//    //イベントの登録
//    print("----登録----")
//    for item in eventArray2{
//        do {
//            try eventStore.save(item, span: .thisEvent, commit: true)
//        } catch let error {
//            print("同期失敗")
//            print(error)
//        }
//    }
//}

struct CalendarData {
    var EventID: String  //標準カレンダーのEKEventの識別子
    var CalendarID: String //realm(DefaultCalendarのcalendarid)
    var Event: EKEvent //標準カレンダーのEKEvent
    
    init(eventid: String, calendarid: String, event: EKEvent) {
        self.EventID = eventid
        self.CalendarID = calendarid
        self.Event = event
    }
}

