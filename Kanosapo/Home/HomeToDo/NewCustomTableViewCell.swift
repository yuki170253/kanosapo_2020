//
//  NewCustomTableViewCell.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/11/02.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

class NewCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var taskname: UILabel!
    @IBOutlet weak var target_time: UILabel!
    @IBOutlet weak var achi_rate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        taskname.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(taskname: String, target_time: String, achi_rate: String){
        self.taskname.text = taskname
        self.target_time.text = target_time
        self.achi_rate.text = achi_rate
    
    }
    
    func setHeader(taskname: String, target_time: String, achi_rate: String){
        self.taskname.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.target_time.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.achi_rate.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.taskname.text = taskname
        self.target_time.text = target_time
        self.achi_rate.text = achi_rate
    }
}
//
//  NewCustomTableViewCell.swift
//  Kanosapo
//
//  Created by 牧内秀介 on 2020/11/17.
//

import Foundation
