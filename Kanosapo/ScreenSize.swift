//
//  ScreenSize.swift
//  Kanosapo
//
//  Created by 牧内秀介 on 2020/12/25.
//

import UIKit

class ScreenSize: NSObject {
    let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    let mainScale: CGFloat = UIScreen.main.scale
    var calScale: CGFloat = 1.0
    var no1point: Int = 30
    var no23point: Int = 1410
    var ratio: CGFloat = 1.0
    
    override init() {
        print("ScreenSize")
        if screenHeight > 926 {
            calScale = 2.0
        }
        no1point *= Int(calScale)
        no23point = no1point + 60 * 23 * Int(calScale)
        if screenHeight / 667.0 < screenWidth / 375.0 {
            ratio = screenHeight / 667.0
        }else {
            ratio = screenWidth / 375.0
        }
    }
}
