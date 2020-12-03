//
//  tabmanDisplay.swift
//  MyTodoList
//
//  Created by yanagimachi_riku on 2019/12/03.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import Foundation
import UIKit

class tabmanDisplay{
    
    let menheraLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let achivedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let evaluatedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 17)
       return label
    }()
    
    
    
    
    //UIImageViewパーツ
    let menhera0Pic: UIImageView = {
        let image = UIImageView(image: UIImage(named: "メンヘラ_SD_0.png"))
        image.contentMode = UIView.ContentMode.scaleAspectFit
        
        return image
    }()
    
    let menhera100Pic: UIImageView = {
        let image = UIImageView(image: UIImage(named: "メンヘラ_SD_100.png"))
        image.contentMode = UIView.ContentMode.scaleAspectFit
        
        return image
    }()
}
