//
//  Firebase.swift
//  Kanosapo
//
//  Created by 牧内秀介 on 2020/11/17.
//

import Foundation
import UIKit
import Firebase
import RealmSwift

func writeFirebase(){
    print("writeFirebase")
    let realm = try! Realm()
    var DBRef:DatabaseReference!
    DBRef = Database.database().reference()
    let f = DateFormatter()
    f.timeStyle = .none
    f.dateStyle = .full
    f.locale = Locale(identifier: "ja_JP")
    //DBRef.child("user/01").setValue(data) //書き込み
    let user_id = UserDefaults.standard.object(forKey: "user_id") as! String //アプリユーザーの識別子
    let todo = realm.objects(Todo.self)
    let cal24 = realm.objects(Calendar24.self)
    let default_cal = realm.objects(DefaultCalendar.self)
    if UserDefaults.standard.object(forKey: "line_id") != nil {
        print("lineIdあり")
        let line_id = ["Line_id": UserDefaults.standard.object(forKey: "line_id") as! String]
        DBRef.child("users/" + user_id).updateChildValues(line_id) //更新
    }
    
    for item in todo {
        var date = ""
        if item.date != nil {
            date = convert_string_details(date: item.date!)
        }
        let data = ["title": item.title,
                    "todoDone": item.todoDone,
                    "donetime": item.donetime,
                    "dotime": item.dotime,
                    "date": date,
                    "datestring": item.datestring,
                    "Inflag": item.InFlag,
                    "base": item.base] as [String : Any]
        DBRef.child("users/" + user_id + "/Todo/" + item.todoid).updateChildValues(data) //更新
    }
    for item in cal24 {
        let data = ["title": item.todo.first!.title,
                    "todoDone": item.todoDone,
                    "donetime": item.todo.first!.donetime,
                    "dotime": item.todo.first!.dotime,
                    "start": convert_string_details(date: item.start),
                    "c_dotime": item.c_dotime,
                    "end": convert_string_details(date: item.end)] as [String : Any]
        DBRef.child("users/" + user_id + "/Calendar24/" + item.calendarid).updateChildValues(data) //更新
    }
    for item in default_cal {
        let data = ["title": item.title,
                    "start": convert_string_details(date: item.start),
                    "end": convert_string_details(date: item.end),
                    "allDay": item.allDay] as [String : Any]
        DBRef.child("users/" + user_id + "/DefaultCalendar/" + item.calendarid).updateChildValues(data) //更新
    }
    //    DBRef.child("user/01").updateChildValues(["age": "20"]) //更新
    //    let defaultPlace = DBRef.child("user/01")
    //    defaultPlace.observe(.value) { (snap: DataSnapshot) in
    //        print("読み込み",(snap.value! as AnyObject).description!) //削除が先に処理される？
    //    }
    //    DBRef.child("user/01/age").removeValue() //削除
}
