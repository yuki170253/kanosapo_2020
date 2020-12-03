//
//  getTimes.swift
//  MyTodoList
//
//  Created by 三浦 on 2020/09/24.
//  Copyright © 2020 古府侑樹. All rights reserved.
//

import UIKit
import Foundation

import EventKit
import RealmSwift


var no1point = 30
var no23point = 1410
func getTaskTime(y: CGFloat) -> (Date){
    let hour = (no23point - no1point)/23
    let minute:Double
    minute = Double(hour)/Double(60)
    
    let format = DateFormatter()
    
    let calendar = Calendar.current
    let date = NSDate() as Date
    let m = calendar.component(.minute, from: date)
    
//    view.frame.origin.y
    
    let starttime = Int(round(Double(Double(y) - Double(no1point)) / minute)) - m
    let startDate = Calendar.current.date(byAdding: .minute, value: starttime, to: date)!
    
    format.dateFormat = "HH:mm"
    format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
    
    print("スタートタイム")
    print(format.string(from: startDate))
    print(y)
    return startDate
}

var nowtimeMark = UIImageView(image:UIImage(named:"triangle")!)
var nowtimeBar = CALayer()

func getnowTime(content: UIView)->UILabel{
    
    let now = NSDate()
    let calendar = Calendar(identifier: .gregorian)
    let m = calendar.component(.minute, from: now as Date)
    let weeks = ["日","月","火","水","木","金","土"]
    nowtimeBar.frame = CGRect(x: 50, y: m % 60 + no1point, width: 310, height: 1)
    nowtimeBar.backgroundColor = UIColor.red.cgColor
    nowtimeMark.frame.size = CGSize(width: 11, height: 15)
    nowtimeMark.center = CGPoint(x: 50, y: m % 60 + no1point)
    content.addSubview(nowtimeMark)
    content.layer.addSublayer(nowtimeBar)
    let component = calendar.component(.weekday, from: now as Date)
    let weekday = component - 1
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en")
    formatter.dateFormat = "yyyy  MM/dd"
    //formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    let nowTime = formatter.string(from: now as Date) + "  (" + weeks[weekday] + ")"
    let nowTimeLabel = UILabel()
    let attrText = NSMutableAttributedString(string: nowTime)
    attrText.addAttribute(.font,
                          value: UIFont.boldSystemFont(ofSize: 25),
                          range: NSMakeRange(6, 5))
    // attributedTextとしてUILabelに追加します.
    nowTimeLabel.attributedText = attrText
    nowTimeLabel.textAlignment = NSTextAlignment.center
    nowTimeLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
    return nowTimeLabel
}
